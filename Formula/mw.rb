# Homebrew formula for the Magicweave CLI (bottled binary — bundles its own Node
# runtime, so it does not depend on `node`).
#
# This is the source-of-truth template. The release workflow fills in the version
# and per-platform SHA-256s and pushes the rendered formula to the tap repo
# `FortuneCasablancas/homebrew-magicweave` (Formula/mw.rb), so users can:
#
#   brew install magicweave/tap/mw
#
# Placeholders replaced at release time: 0.6.0, ba254a91022d1732881cc5e6e26e1c62c5d9e6c7fa4762f3f851e661b75596de, etc.
class Mw < Formula
  desc "Magicweave developer CLI — build, validate, and ship game economies"
  homepage "https://www.magicweave.xyz"
  version "0.6.0"
  license "MIT"

  base = "https://dl.magicweave.xyz/v0.6.0"

  on_macos do
    if Hardware::CPU.arm?
      url "#{base}/magicweave-0.6.0-darwin-arm64.tar.gz"
      sha256 "ba254a91022d1732881cc5e6e26e1c62c5d9e6c7fa4762f3f851e661b75596de"
    else
      url "#{base}/magicweave-0.6.0-darwin-x64.tar.gz"
      sha256 "f6a75b77da66e8a8a0b545efa6e0379615c345c0918e0a95d2a85d743d96c41d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "#{base}/magicweave-0.6.0-linux-arm64.tar.gz"
      sha256 "6d7cc92d2dd4b03f51cddd8978fe2dee2abfa34bcf47077b4250c8ae447e1b1b"
    else
      url "#{base}/magicweave-0.6.0-linux-x64.tar.gz"
      sha256 "bac6e429594ffd092917294b530dc59f942602fa1346f7793d9d12e7359838f1"
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
