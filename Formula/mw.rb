# Homebrew formula for the Magicweave CLI (bottled binary — bundles its own Node
# runtime, so it does not depend on `node`).
#
# This is the source-of-truth template. The release workflow fills in the version
# and per-platform SHA-256s and pushes the rendered formula to the tap repo
# `FortuneCasablancas/homebrew-magicweave` (Formula/mw.rb), so users can:
#
#   brew install magicweave/tap/mw
#
# Placeholders replaced at release time: 0.5.0, dfdfb62c4b3637b9fd111522f866e2a6a2875db761927d8ac4e25f40a3d89a5d, etc.
class Mw < Formula
  desc "Magicweave developer CLI — build, validate, and ship game economies"
  homepage "https://www.magicweave.xyz"
  version "0.5.0"
  license "MIT"

  base = "https://dl.magicweave.xyz/v0.5.0"

  on_macos do
    if Hardware::CPU.arm?
      url "#{base}/magicweave-0.5.0-darwin-arm64.tar.gz"
      sha256 "dfdfb62c4b3637b9fd111522f866e2a6a2875db761927d8ac4e25f40a3d89a5d"
    else
      url "#{base}/magicweave-0.5.0-darwin-x64.tar.gz"
      sha256 "7057eb762710dba6520db5b0bafe54a4f2f9ad2bcf46ed1555e0c9bbb2161579"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "#{base}/magicweave-0.5.0-linux-arm64.tar.gz"
      sha256 "4716924ff673831d1ea6a7402679a1e2b402ef8214278d64f3c4cab5d44522bb"
    else
      url "#{base}/magicweave-0.5.0-linux-x64.tar.gz"
      sha256 "80592974d87c4135493e6b236ca959dbccfcf7f009dffa13214948caef8d3537"
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
