class ThanksStars < Formula
  desc "Star the GitHub repositories backing your project's dependencies from the command line."
  homepage "https://github.com/Kenzo-Wada/thanks-stars"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Kenzo-Wada/thanks-stars/releases/download/v0.3.0/thanks-stars-aarch64-apple-darwin.tar.gz"
      sha256 "042833ae2bca9efe363dbaaa074936b1a0158759357240f719906070ddc50dd9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Kenzo-Wada/thanks-stars/releases/download/v0.3.0/thanks-stars-x86_64-apple-darwin.tar.gz"
      sha256 "45fc3fcf70399893af15230bdadbd6f62298e903bfed9cdd1ee4f925743ec46d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Kenzo-Wada/thanks-stars/releases/download/v0.3.0/thanks-stars-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "d04ef4b8fc19f60bf71fe8428433b228a2cafeb3dce5798fb97fb962c0abc3dd"
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
