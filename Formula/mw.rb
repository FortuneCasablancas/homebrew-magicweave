# Homebrew formula for the Magicweave CLI (bottled binary — bundles its own Node
# runtime, so it does not depend on `node`).
#
# This is the source-of-truth template. The release workflow fills in the version
# and per-platform SHA-256s and pushes the rendered formula to the tap repo
# `FortuneCasablancas/homebrew-magicweave` (Formula/mw.rb), so users can:
#
#   brew install magicweave/tap/mw
#
# Placeholders replaced at release time: 0.3.0, 1202f43db20d797a44a4e9c58f6f5fd5dbcb15c9e9738228d1e7bf4c7efd5371, etc.
class Mw < Formula
  desc "Magicweave developer CLI — build, validate, and ship game economies"
  homepage "https://www.magicweave.xyz"
  version "0.3.0"
  license "MIT"

  base = "https://dl.magicweave.xyz/v0.3.0"

  on_macos do
    if Hardware::CPU.arm?
      url "#{base}/magicweave-0.3.0-darwin-arm64.tar.gz"
      sha256 "1202f43db20d797a44a4e9c58f6f5fd5dbcb15c9e9738228d1e7bf4c7efd5371"
    else
      url "#{base}/magicweave-0.3.0-darwin-x64.tar.gz"
      sha256 "b6472c2a8e3cd129e925d8619b0ccff2fef0c9ff038fcd4469055911fd9d7b53"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "#{base}/magicweave-0.3.0-linux-arm64.tar.gz"
      sha256 "745dd2a4f40517c90d2761eaec70c076a9eacca1e3bb8f6c851459d84f307322"
    else
      url "#{base}/magicweave-0.3.0-linux-x64.tar.gz"
      sha256 "36af62bdc08452820dd142de5f893489a802a4a2f02475e954b515afff0be798"
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
