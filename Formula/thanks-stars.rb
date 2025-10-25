class ThanksStars < Formula
  desc "Star the GitHub repositories backing your project's dependencies from the command line."
  homepage "https://github.com/Kenzo-Wada/thanks-stars"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Kenzo-Wada/thanks-stars/releases/download/v0.6.0/thanks-stars-aarch64-apple-darwin.tar.gz"
      sha256 "10b14a596a77f41d256eed627f7ef9ffb33b32f0548d0e04f8274a18ee1a353e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Kenzo-Wada/thanks-stars/releases/download/v0.6.0/thanks-stars-x86_64-apple-darwin.tar.gz"
      sha256 "377be639d6292a674ccd4ee31486c7fd9ecf64bf2096490bee2d41cb47b4f74c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Kenzo-Wada/thanks-stars/releases/download/v0.6.0/thanks-stars-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "33fdc9b2ef5b748400a8bfccb05ddc4d467f51dbb60864f8a601a6eed8aa0260"
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
