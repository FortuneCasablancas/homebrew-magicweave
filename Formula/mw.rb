# Homebrew formula for the Magicweave CLI (bottled binary — bundles its own Node
# runtime, so it does not depend on `node`).
#
# This is the source-of-truth template. The release workflow fills in the version
# and per-platform SHA-256s and pushes the rendered formula to the tap repo
# `FortuneCasablancas/homebrew-magicweave` (Formula/mw.rb), so users can:
#
#   brew install magicweave/tap/mw
#
# Placeholders replaced at release time: 0.8.0, 0f06b199a2ea507390d77ea1f2ca0d45b5e33cb8240c0f528fbba443ec14134e, etc.
class Mw < Formula
  desc "Magicweave developer CLI — build, validate, and ship game economies"
  homepage "https://www.magicweave.xyz"
  version "0.8.0"
  license "MIT"

  base = "https://dl.magicweave.xyz/v0.8.0"

  on_macos do
    if Hardware::CPU.arm?
      url "#{base}/magicweave-0.8.0-darwin-arm64.tar.gz"
      sha256 "0f06b199a2ea507390d77ea1f2ca0d45b5e33cb8240c0f528fbba443ec14134e"
    else
      url "#{base}/magicweave-0.8.0-darwin-x64.tar.gz"
      sha256 "b4fb5c4237a16d534fda0de2cfda041f32caa15401b96a8c26bb67b672056428"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "#{base}/magicweave-0.8.0-linux-arm64.tar.gz"
      sha256 "ac1230af78e600f06b6fe6c4ecdce0e201be2014e38becd820ce7556dc02a5e7"
    else
      url "#{base}/magicweave-0.8.0-linux-x64.tar.gz"
      sha256 "90e93d0a95482653aa7bce1a9c0e839ec35bdd7cf882e26d69d479955646e06b"
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
