class ThanksStars < Formula
  desc "Star the GitHub repositories backing your project's dependencies from the command line."
  homepage "https://github.com/Kenzo-Wada/thanks-stars"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Kenzo-Wada/thanks-stars/releases/download/v0.7.1/thanks-stars-aarch64-apple-darwin.tar.gz"
      sha256 "d6f02df2a2786ce078ea2f4bd034ac6e1483ca4ffeb2eb213adcd869d83f8328"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Kenzo-Wada/thanks-stars/releases/download/v0.7.1/thanks-stars-x86_64-apple-darwin.tar.gz"
      sha256 "cba2e6bc878adc6deab7288e09108250cadb6b3bba39a6903a535ae2db8cc5b7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Kenzo-Wada/thanks-stars/releases/download/v0.7.1/thanks-stars-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "597b4e81d7c4a54f903fc4e3f494bb4937b581dd8c11ddd70e75407b75f9e145"
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
