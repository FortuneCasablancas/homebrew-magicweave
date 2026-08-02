# Homebrew formula for the Magicweave CLI (bottled binary — bundles its own Node
# runtime, so it does not depend on `node`).
#
# This is the source-of-truth template. The release workflow fills in the version
# and per-platform SHA-256s and pushes the rendered formula to the tap repo
# `FortuneCasablancas/homebrew-magicweave` (Formula/mw.rb), so users can:
#
#   brew install magicweave/tap/mw
#
# Placeholders replaced at release time: 0.4.0, 11afba85fae453d9f619fd5df8f0cdf370ca6ffbd3e0e3fbe4bd0c3523f3e2a9, etc.
class Mw < Formula
  desc "Magicweave developer CLI — build, validate, and ship game economies"
  homepage "https://www.magicweave.xyz"
  version "0.4.0"
  license "MIT"

  base = "https://dl.magicweave.xyz/v0.4.0"

  on_macos do
    if Hardware::CPU.arm?
      url "#{base}/magicweave-0.4.0-darwin-arm64.tar.gz"
      sha256 "11afba85fae453d9f619fd5df8f0cdf370ca6ffbd3e0e3fbe4bd0c3523f3e2a9"
    else
      url "#{base}/magicweave-0.4.0-darwin-x64.tar.gz"
      sha256 "a2dc127683d389f378e2fdc662205ee060c88e5f6fe66a2630f6618365b33ab0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "#{base}/magicweave-0.4.0-linux-arm64.tar.gz"
      sha256 "f7ffe7bf148a0fcbe802f8d68f2aa876d4dd4357d6dd135b1faf3dfd9b74eb6d"
    else
      url "#{base}/magicweave-0.4.0-linux-x64.tar.gz"
      sha256 "6f9ecfff36be3fa738394c64084748c5b5be554797f73eebe7aea32c5cd86ea0"
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
