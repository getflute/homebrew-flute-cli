class Flute < Formula
  desc "Cross-platform CLI for the Flute payments platform"
  homepage "https://github.com/getflute/flute-cli"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli/releases/download/v0.1.6/flute-aarch64-apple-darwin.tar.xz"
      sha256 "7dc52b1d0e08b09f39ea3b59dbac87cc9191e8efe825fa7b706ce6b518197d59"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli/releases/download/v0.1.6/flute-x86_64-apple-darwin.tar.xz"
      sha256 "ccfde45906b28ac240907e2fbcf17f10fa9f977b0f13913b3870508537d639e0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli/releases/download/v0.1.6/flute-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3b8e2fff2a59aae6ff44899c2e99c00c11cc5c0b7dc2f5879cc84d1430fd8a71"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli/releases/download/v0.1.6/flute-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0c8ed037ef0c63b56fa3101a7b939f2f20ca70aa4d63c513c58eddfc29e0d540"
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
