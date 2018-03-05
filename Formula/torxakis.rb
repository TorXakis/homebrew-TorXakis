
class Torxakis < Formula
  desc "Tool for Model Based Testing"
  homepage "https://github.com/TorXakis/TorXakis"
  url "https://github.com/TorXakis/TorXakis/archive/v0.5.0.tar.gz"
  sha256 "03b370d2145206769e6cd12935404c5235a2afa6a779aef0aa3d0030057c6375"
  head "https://github.com/TorXakis/TorXakis.git"

  bottle do
    cellar :any_skip_relocation
    root_url "https://github.com/TorXakis/TorXakis/releases/download/v0.5.0/"
    sha256 "1f8a845a2e8c3622a5d6590aa07fc1f44dee1d1315216f823feb41850be388af" => :high_sierra
    sha256 "e8ef8d4f47bb081fffa3d8b7bf25535fd2c6963df38ecfd7a2c8e3676c87ffe8" => :sierra
    sha256 "139c428b838f459ebeef7ea1984a26280cae1f0749e44ec0888f766b9f61877c" => :el_capitan
  end

  depends_on "haskell-stack" => :build
  depends_on "z3" => :run

  def install
    ohai "running install"
    jobs = ENV.make_jobs
    ENV.deparallelize
    system "stack", "-j#{jobs}", "--stack-yaml=stack_linux.yaml", "setup"
    system "stack", "-j#{jobs}", "--stack-yaml=stack_linux.yaml", "--local-bin-path=#{bin}", "install"
    prefix.install "examps"
    prefix.install "docs"
  end

  test do
    ohai "running basic test"
    output_torxakis = pipe_output('printf "eval 33+7777777777777\nq" |torxakis  2>&1')
    assert_match(/7777777777810/, output_torxakis, 'torxakis failed in doing "eval 33+7777777777777"')
    ohai "test succesfull"
  end
end
