class Flute < Formula
  desc "Cross-platform CLI for the Flute payments platform"
  homepage "https://github.com/getflute/flute-cli"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli/releases/download/v1.0.1/flute-aarch64-apple-darwin.tar.xz"
      sha256 "238ab0f2fa7661544d8178a020abfde5ecd9c3c2d7a67b092a6fa1fbef1927c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli/releases/download/v1.0.1/flute-x86_64-apple-darwin.tar.xz"
      sha256 "fade5e24a795d97f031f504ba330295853990a9f7bab162160854bdb42854097"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli/releases/download/v1.0.1/flute-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5caf58f6759dad7d1f854fc7f53fb40a0d4fcb24b0d8cd41d7b475e13419ece4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli/releases/download/v1.0.1/flute-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b48514a635a4ea623034e205fae28caf9581d46dd3f3c3ed4c05fe69034a5096"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "flute" if OS.mac? && Hardware::CPU.arm?
    bin.install "flute" if OS.mac? && Hardware::CPU.intel?
    bin.install "flute" if OS.linux? && Hardware::CPU.arm?
    bin.install "flute" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
