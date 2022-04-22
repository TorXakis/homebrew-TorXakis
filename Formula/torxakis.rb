# typed: false
# frozen_string_literal: true

# torxakis: a tool for model-based testing
class Torxakis < Formula
  desc "Tool for Model Based Testing"
  homepage "https://github.com/TorXakis/TorXakis"
  url "https://github.com/TorXakis/TorXakis/archive/v0.9.0.tar.gz"
  sha256 "2629a602c1dc33224336cffc05292484951233f624a64b04648f947dba6c0d94"
  head "https://github.com/TorXakis/TorXakis.git"

  bottle do
    root_url "https://github.com/TorXakis/TorXakis/releases/download/v0.9.0/"
    # next line is a HACK to allow brew on a ARM mac install intel version of torxakis in /opt/homebrew (for arm software) from the intel bottle below
    # note: torxakis and txsserver are standalone intel binaries which can run fine under Rosetta2 
    sha256 cellar: :any_skip_relocation, arm64_monterey:    "5cc7620b12bbfb4d1eb72c25727568b8faae504f71dac1da6ba111274fe68108"
    sha256 cellar: :any_skip_relocation, monterey:    "5cc7620b12bbfb4d1eb72c25727568b8faae504f71dac1da6ba111274fe68108" 
    sha256 cellar: :any_skip_relocation, catalina:    "cf324a1c404ddf083e55e55b907a77371ca9f91ca4f2b20bc5434ebbeb3d923e"
    sha256 cellar: :any_skip_relocation, mojave:      "dbb245251780eaeb96987754b3cfa780c9fa4bce541ffd20984d7eb73fe195f9"
    sha256 cellar: :any_skip_relocation, high_sierra: "72c26afb6c1129038063b51d76bc0566d67c337402b378e2f50b1b766e7a4965"    
  end

  depends_on "haskell-stack" => :build
  depends_on "TorXakis/TorXakis/z3@4.8.7"
  depends_on "TorXakis/TorXakis/cvc4@1.7"

  def install
    ohai "running install"
    jobs = ENV.make_jobs
    ENV.deparallelize

    system "stack", "-j#{jobs}", "--stack-yaml=stack_linux.yaml", "setup"
    system "stack", "-j#{jobs}", "--stack-yaml=stack_linux.yaml", "--local-bin-path=#{bin}", "install"
    prefix.install "examps"
    prefix.install "docs"
  end
 
  # post install does install wrapper for txsserver so we can use fixed  z3@4.8.7 and cvc4@1.7 versions which are installed keg-only
  def post_install
    ohai "running post install"
    system "mv", "#{prefix}/bin/txsserver", "#{prefix}/bin/wrapped_txsserver"
    system "curl", "-Lo", "#{prefix}/bin/txsserver", "https://raw.githubusercontent.com/TorXakis/homebrew-TorXakis/v0.9.0/scripts/wrapper_for_txsserver_homebrew.bash" 
    system "chmod", "+x", "#{prefix}/bin/txsserver"
  end  
  

  test do
    ohai "running basic test"
    output_torxakis = pipe_output('printf "eval 33+7777777777777\nq" |torxakis  2>&1')
    assert_match(/7777777777810/, output_torxakis, 'torxakis failed in doing "eval 33+7777777777777"')
    ohai "test succesfull"
  end
end
