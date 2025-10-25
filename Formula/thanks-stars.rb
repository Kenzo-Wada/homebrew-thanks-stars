class ThanksStars < Formula
  desc "Star the GitHub repositories backing your project's dependencies from the command line."
  homepage "https://github.com/Kenzo-Wada/thanks-stars"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Kenzo-Wada/thanks-stars/releases/download/v0.7.2/thanks-stars-aarch64-apple-darwin.tar.gz"
      sha256 "5873cd8a1a550476066ecfab80347d702d61f4a465588f21b20ae28ba6648bf5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Kenzo-Wada/thanks-stars/releases/download/v0.7.2/thanks-stars-x86_64-apple-darwin.tar.gz"
      sha256 "efa290b811f84ede2217c58976c6f0fed8c804b6b6dfa7d4aeac28525cad11ca"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Kenzo-Wada/thanks-stars/releases/download/v0.7.2/thanks-stars-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "754b755594459cb4f99ea1a93e21af9abcb17c372ba4c3a2eece84aba2f5962f"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "thanks-stars" if OS.mac? && Hardware::CPU.arm?
    bin.install "thanks-stars" if OS.mac? && Hardware::CPU.intel?
    bin.install "thanks-stars" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
