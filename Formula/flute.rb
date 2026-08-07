class Flute < Formula
  desc "Cross-platform CLI for the Flute payments platform"
  homepage "https://github.com/getflute/flute-cli"
  version "1.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli/releases/download/v1.1.1/flute-aarch64-apple-darwin.tar.xz"
      sha256 "71c7b4de24944c867f6285f109c11f5c5d8776de52f7c7bffcd6f72d8c06dd17"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli/releases/download/v1.1.1/flute-x86_64-apple-darwin.tar.xz"
      sha256 "0dd119cc9c4e4589143a09c3ddea2c8ff8e1f596c8d05be4cba52497021f5c0b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli/releases/download/v1.1.1/flute-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2bcad61fff5c0163fb99ef7a5c91fad9e3e2b27e46881b2f18bbbe67c34bce63"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli/releases/download/v1.1.1/flute-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "83dd9e39b909f24a9f5f65e569a4c3f1163c80672269f4d80dbdb2baff92d960"
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
