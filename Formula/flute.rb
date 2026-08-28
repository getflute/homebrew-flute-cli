class Flute < Formula
  desc "Cross-platform CLI for the Flute payments platform"
  homepage "https://github.com/getflute/flute-cli"
  version "1.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli/releases/download/v1.1.3/flute-aarch64-apple-darwin.tar.xz"
      sha256 "7e57dde9b6f0ac684cb5dbe8a8aa9135e13bd9343542c9982fcb1494cc972605"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli/releases/download/v1.1.3/flute-x86_64-apple-darwin.tar.xz"
      sha256 "aaf13058a6524375b7c376c8b4ae7bc06b3190c86925f7d53d20293142fadd5d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli/releases/download/v1.1.3/flute-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "118e322c3ef1f1e27c362b7a1ea5180265091f044e0e1d74a63ce7b691acd697"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli/releases/download/v1.1.3/flute-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "563b4a2390ca45373cd028b749b83b080ce6be8b8ca3ce443f55ddf621efcf75"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "flute"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "flute"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "flute"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "flute"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
