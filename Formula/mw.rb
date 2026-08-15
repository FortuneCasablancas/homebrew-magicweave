# Homebrew formula for the Magicweave CLI (bottled binary — bundles its own Node
# runtime, so it does not depend on `node`).
#
# This is the source-of-truth template. The release workflow fills in the version
# and per-platform SHA-256s and pushes the rendered formula to the tap repo
# `FortuneCasablancas/homebrew-magicweave` (Formula/mw.rb), so users can:
#
#   brew install magicweave/tap/mw
#
# Placeholders replaced at release time: 0.9.0, a4942b1ac2c8c6ea1ff655dbab2da4ce75cc9968287b67476c74d2a8c57f5e83, etc.
class Mw < Formula
  desc "Magicweave developer CLI — build, validate, and ship game economies"
  homepage "https://www.magicweave.xyz"
  version "0.9.0"
  license "MIT"

  base = "https://dl.magicweave.xyz/v0.9.0"

  on_macos do
    if Hardware::CPU.arm?
      url "#{base}/magicweave-0.9.0-darwin-arm64.tar.gz"
      sha256 "a4942b1ac2c8c6ea1ff655dbab2da4ce75cc9968287b67476c74d2a8c57f5e83"
    else
      url "#{base}/magicweave-0.9.0-darwin-x64.tar.gz"
      sha256 "a63b0063c42786ccadc0fff76f80a28411685b7cb145040bbdbfa4d45d320a9e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "#{base}/magicweave-0.9.0-linux-arm64.tar.gz"
      sha256 "d329c71b098652d77e8798c511859acccbfcf6f8a860f8935cba568fe07fc1ae"
    else
      url "#{base}/magicweave-0.9.0-linux-x64.tar.gz"
      sha256 "74f6f59230a239f179e3e54c3c4463ae3d703ab386f583dc623dbf412a442883"
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
