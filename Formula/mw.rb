# Homebrew formula for the Magicweave CLI (bottled binary — bundles its own Node
# runtime, so it does not depend on `node`).
#
# This is the source-of-truth template. The release workflow fills in the version
# and per-platform SHA-256s and pushes the rendered formula to the tap repo
# `FortuneCasablancas/homebrew-magicweave` (Formula/mw.rb), so users can:
#
#   brew install magicweave/tap/mw
#
# Placeholders replaced at release time: 0.2.1, 49538897b1a6be37c8f1ed221a223cbb2c5bdf7b9f2af56db2f4e0190819531b, etc.
class Mw < Formula
  desc "Magicweave developer CLI — build, validate, and ship game economies"
  homepage "https://www.magicweave.xyz"
  version "0.2.1"
  license "MIT"

  base = "https://dl.magicweave.xyz/v0.2.1"

  on_macos do
    if Hardware::CPU.arm?
      url "#{base}/magicweave-0.2.1-darwin-arm64.tar.gz"
      sha256 "49538897b1a6be37c8f1ed221a223cbb2c5bdf7b9f2af56db2f4e0190819531b"
    else
      url "#{base}/magicweave-0.2.1-darwin-x64.tar.gz"
      sha256 "592a485c1801e992631d9213a6bcfc36c710ea3412de510dce86123597586237"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "#{base}/magicweave-0.2.1-linux-arm64.tar.gz"
      sha256 "100dc993b72fffb6a473dadfffd29d78a405872ec2283046b1b3e658f2db8c6d"
    else
      url "#{base}/magicweave-0.2.1-linux-x64.tar.gz"
      sha256 "db58d7a7cb7c09e323d7b8839cf28d6f3ede8fdaf8c5e8543a301b9c91ae5c8f"
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
