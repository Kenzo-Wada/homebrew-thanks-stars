class ThanksStars < Formula
  desc "Star the GitHub repositories backing your project's dependencies from the command line."
  homepage "https://github.com/Kenzo-Wada/thanks-stars"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Kenzo-Wada/thanks-stars/releases/download/v0.7.0/thanks-stars-aarch64-apple-darwin.tar.gz"
      sha256 "3e8deb4d23ccae37dd57e4ae238b786740bde87e9aba33e50891e6b3827f0967"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Kenzo-Wada/thanks-stars/releases/download/v0.7.0/thanks-stars-x86_64-apple-darwin.tar.gz"
      sha256 "5e53b253f5ab2f917f2c973efd2632a9ea055a72789779097b9f1021b57b7b86"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Kenzo-Wada/thanks-stars/releases/download/v0.7.0/thanks-stars-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "500f8408f504928a3dab8f390aee6a817e3603b3982dbb0317b456874d7aa467"
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
