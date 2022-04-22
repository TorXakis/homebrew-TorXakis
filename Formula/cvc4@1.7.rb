class Cvc4AT17 < Formula
  include Language::Python::Virtualenv

  desc "Open-source automatic theorem prover for SMT"
  homepage "https://cvc4.cs.stanford.edu/"
  #url "https://github.com/CVC4/CVC4/archive/1.7.tar.gz"
  url "https://github.com/TorXakis/Dependencies/releases/download/cvc4_1.7/cvc4-1.7.source.tar.gz"
  sha256 "f582327a98922c4323f9d7c861b39f80aea1e25477ac31de500d235e78f1063e"
  head "https://github.com/CVC4/CVC4.git"

  keg_only "only provided for torxakis to guaranteed no incompatibilities which newer versions of cvc4 may have"
  
  bottle do
    root_url "https://github.com/TorXakis/Dependencies/releases/download/cvc4_1.7/"
    sha256 cellar: :any, arm64_monterey: "2cc7de2eb70c856b2ce8c113b295b50bdea633a4706858d4c92fcff92a6cecda"
    sha256 cellar: :any, catalina: "196e458ab72040f4ffc15c45e232b9373d865f7cd822616d2e20050c8407faf3"
  end

  option "with-java-bindings", "Compile with Java bindings"
  option "with-gpl", "Allow building against GPL'ed libraries"

  depends_on "coreutils" => :build
  depends_on "cmake" => :build
  depends_on "python" => :build
  depends_on "gmp"  
  depends_on "readline" => :optional
  depends_on :java if build.with? "java-bindings"
  depends_on "swig"
  depends_on "automake" => :build if not build.head?
  depends_on "libtool" => :build if not build.head?
  depends_on "cryptominisat" 
  #depends_on :arch => :x86_64

  patch :p1 do
    url "https://github.com/TorXakis/Dependencies/releases/download/cvc4_1.7/cvc4-1.7_get-antlr-3.4.patch"
    sha256 "1b2dd452badb13f96944dd35121a36e84f864dac4970cd41733c226bd2af0444"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/b9/19/5cbd78eac8b1783671c40e34bb0fa83133a06d340a38b55c645076d40094/toml-0.10.0.tar.gz"
    sha256 "229f81c57791a41d65e399fc06bf0848bab550a9dfd5ed66df18ce5f05e73d5c"
  end

  def run_in_venv(venv, cmd)
    activate = Shellwords.join(["source", "#{venv}/bin/activate"])
    cmd_str = Shellwords.join(cmd)
    system "bash", "-c", (activate + " && " + cmd_str)
  end

  def install
    jobs = ENV.make_jobs
    system "contrib/get-antlr-3.4"
    system "contrib/get-symfpu"

    args = ["--prefix=#{prefix}",
            "--symfpu",
            "--cryptominisat"]

    venv_root = "#{buildpath}/venv"
    if build.head?
      venv = virtualenv_create(venv_root, "python3")
      venv.pip_install resources
    else
      args << "--python3"
    end

    if build.with? "java-bindings"
      args << "--language-bindings=java"
    end

    if allow_gpl?
      args << "--gpl"
    end

    if build.with? "readline"
      gpl_dependency "readline"
      args << "--readline"
    end

    if build.head?
      run_in_venv(venv_root, ["./configure.sh", *args])
      chdir "build" do
        run_in_venv(venv_root, ["make", "install"])
      end
    else
      system "./configure.sh", *args
      chdir "build" do
        system "make", "-j#{jobs}"
        system "make", "-j#{jobs}", "install"
      end
      ## Importing external libraries was not successful because the external libraries themselves
      ## have dependendencies to external dylibs. So we need to do it recursively, making it more complex
      ## to implement. We therefore deciced not to import external libraries, but keep them as dependencies
      ## to this package. If the torxakis package hides this package in its own package, it must take over
      ## the dependencies of the cvc4 package, to make sure they are installed.
      #system "curl", "-LO",  "https://github.com/TorXakis/Dependencies/releases/download/cvc4_1.7/import_libs"
      #system "bash", "import_libs", "#{prefix}/bin/cvc4", "libcryptominisat", "libgmp"
      
      # add rpath relative to the executable, so that we easily can move this package to another location
      # note: is needed to let torxakis hide this package in its own package to prevent conflict with
      #       another systemwide cvc4 installation
#      system "install_name_tool", "-add_rpath",  "@executable_path/../lib", "#{prefix}/bin/cvc4"
      
    end
  end

  test do
    (testpath/"simple.cvc").write <<~EOS
      x0, x1, x2, x3 : BOOLEAN;
      ASSERT x1 OR NOT x0;
      ASSERT x0 OR NOT x3;
      ASSERT x3 OR x2;
      ASSERT x1 AND NOT x1;
      % EXPECT: valid
      QUERY x2;
    EOS
    result = shell_output "#{bin}/cvc4 #{(testpath/"simple.cvc")}"
    assert_match /valid/, result
    (testpath/"simple.smt").write <<~EOS
      (set-option :produce-models true)
      (set-logic QF_BV)
      (define-fun s_2 () Bool false)
      (define-fun s_1 () Bool true)
      (assert (not s_1))
      (check-sat)
    EOS
    result = shell_output "#{bin}/cvc4 --lang smt #{(testpath/"simple.smt")}"
    assert_match /unsat/, result
  end

  private

  def allow_gpl?
    build.with?("gpl")
  end

  def gpl_dependency(dep)
    odie "--with-gpl is required to build with #{dep}" unless allow_gpl?
  end
end
