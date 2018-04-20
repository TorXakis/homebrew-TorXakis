
class Torxakis < Formula
  desc "Tool for Model Based Testing"
  homepage "https://github.com/TorXakis/TorXakis"
  url "https://github.com/TorXakis/TorXakis/archive/v0.6.0.tar.gz"
  sha256 "c4c9e668580528dabd07f99d0c5534905cebdcf670e6ff1901be77a8a0dc9cfc"
  head "https://github.com/TorXakis/TorXakis.git"

  bottle do
    cellar :any_skip_relocation
    root_url "https://github.com/TorXakis/TorXakis/releases/download/v0.6.0/"
    sha256 "98ad4d2fd0bce23a86555cc4464593fff816e295f44b08c2a52e0e1fc904d86a" => :high_sierra
    sha256 "83fd14a4d4b4b8d68ea3fdd580a88897265ae7cb8246241168860f155aff1bbb" => :sierra
    sha256 "d7e31605795b25dddfce047acf413b19974c83b6b3a1a58d4925a2beddb49c9a" => :el_capitan
  end

  depends_on "haskell-stack" => :build
  depends_on "z3"

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
