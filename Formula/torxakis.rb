
class Torxakis < Formula
  desc "Tool for Model Based Testing"
  homepage "https://github.com/TorXakis/TorXakis"
  url "https://github.com/TorXakis/TorXakis/archive/v0.7.0.tar.gz"
  sha256 "46a78b4303b170aa37f8da36bbe2e8ff27952575e98dcca608e1123a8d74c5d0"
  head "https://github.com/TorXakis/TorXakis.git"

  depends_on "haskell-stack" => :build
  depends_on "z3"

  bottle do
    cellar :any_skip_relocation
    root_url "https://github.com/TorXakis/TorXakis/releases/download/v0.6.0/"
    sha256 "39f8cccbf22a9c3ac0d6c6f683532cecc5b61a7068ca2abee9868210d3473fcd" => :high_sierra
    sha256 "adeeee80220f393cb87a0bb132a56b69922380c64aa78b23350feafa29b74f8b" => :sierra
    sha256 "d2bdedcbeeecdc21fdae691edb87edec6599eede460fdd62b2966759639af5b0" => :el_capitan
  end

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
