# Homebrew formula for the Magicweave CLI (bottled binary — bundles its own Node
# runtime, so it does not depend on `node`).
#
# This is the source-of-truth template. The release workflow fills in the version
# and per-platform SHA-256s and pushes the rendered formula to the tap repo
# `FortuneCasablancas/homebrew-magicweave` (Formula/mw.rb), so users can:
#
#   brew install magicweave/tap/mw
#
# Placeholders replaced at release time: 0.7.0, 324af0e74b0801feef3b0a83555f2745c9589d8a00625191ae4d6c207f12e502, etc.
class Mw < Formula
  desc "Magicweave developer CLI — build, validate, and ship game economies"
  homepage "https://www.magicweave.xyz"
  version "0.7.0"
  license "MIT"

  base = "https://dl.magicweave.xyz/v0.7.0"

  on_macos do
    if Hardware::CPU.arm?
      url "#{base}/magicweave-0.7.0-darwin-arm64.tar.gz"
      sha256 "324af0e74b0801feef3b0a83555f2745c9589d8a00625191ae4d6c207f12e502"
    else
      url "#{base}/magicweave-0.7.0-darwin-x64.tar.gz"
      sha256 "db921bab7f716a9e2ebee4938a35bbd0095ce5037797e46d6ce18c666d64abce"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "#{base}/magicweave-0.7.0-linux-arm64.tar.gz"
      sha256 "122d05908eb37b96359a8993c091a2f0a4a8a5a913abdf75b9118e5c0de30baa"
    else
      url "#{base}/magicweave-0.7.0-linux-x64.tar.gz"
      sha256 "8ea87e84524ec74ac662eca5c41136c2b3a7a85974d87653bc954e13cdffae7f"
    end
  end

  def install
    # The tarball has a single top-level `magicweave/` dir; Homebrew extracts and
    # cd's into it, so node/client/bin are at the current root.
    libexec.install "node", "client", "bin"
    (bin/"mw").write <<~SH
      #!/bin/sh
      exec "#{libexec}/node" "#{libexec}/client/bin/run.js" "$@"
    SH
    chmod 0755, bin/"mw"
  end

  test do
    assert_match "@magicweave/cli", shell_output("#{bin}/mw --version")
  end
end
