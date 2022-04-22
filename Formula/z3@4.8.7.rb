class Z3AT487 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.7.tar.gz"
  sha256 "8c1c49a1eccf5d8b952dadadba3552b0eac67482b8a29eaad62aa7343a0732c3"
  head "https://github.com/Z3Prover/z3.git"
  
  keg_only "only provided for torxakis to guaranteed no incompatibilities which newer versions of z3 may have"
  #conflicts_with "z3", because: "torxakis installs an older version of z3 to prevent compatibility problems" 

  bottle do
    root_url "https://github.com/TorXakis/Dependencies/releases/download/z3-4.8.7/"
    sha256 cellar: :any, arm64_monterey: "57958bf2072786a623cc8c6f8f53857748e307efc35cbc79d084e907e048fb01"
    #sha256 cellar: :any, catalina: "6dbe6b66d4d1884f6ab476b4fecdd19602bde08567b365ca6f38f057f81c9da0"
  end


  depends_on "python"

  def install
    jobs = ENV.make_jobs
    xy = Language::Python.major_minor_version "python3"
    system "python3", "scripts/mk_make.py",
                      "--prefix=#{prefix}",
                      "--python",
                      "--pypkgdir=#{lib}/python#{xy}/site-packages",
                      "--staticlib"
    #                  "--staticbin"
    # note: apple doesn't support compiling static because doesn't provide crt0.0 
    #      see: https://developer.apple.com/library/archive/qa/qa1118/_index.html
    #           has important message:
    #              Apple does not support statically linked binaries on Mac OS X. A statically linked binary assumes 
    #              binary compatibility at the kernel system call interface, and we do not make any guarantees on that
    #              front. Rather, we strive to ensure binary compatibility in each dynamically linked system library
    #              and framework.
    
    cd "build" do
      system "make", "-j#{jobs}"
      system "make", "install"
    end

    system "make", "-C", "contrib/qprofdiff"
    bin.install "contrib/qprofdiff/qprofdiff"

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lz3",
           pkgshare/"examples/c/test_capi.c", "-o", testpath/"test"
    system "./test"
  end
end
