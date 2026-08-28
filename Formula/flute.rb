class Flute < Formula
  desc "Cross-platform CLI for the Flute payments platform"
  homepage "https://github.com/getflute/flute-cli"
  version "1.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli/releases/download/v1.1.2/flute-aarch64-apple-darwin.tar.xz"
      sha256 "db4ffd72e5a2f604de5d2ab89ca9bb3f2c5ea1ae69e283abc681707fa03e01be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli/releases/download/v1.1.2/flute-x86_64-apple-darwin.tar.xz"
      sha256 "7db54557aa9e331aa598667f9cc730ef9eacfd535e7dc98381126d490f1745c8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli/releases/download/v1.1.2/flute-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "775579dfa47eeecfb86a17c9ba422bff83350e6a9c84b8328b6ea96f9675cb4c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli/releases/download/v1.1.2/flute-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a21f53aef8e2502ebaef2385a1fb3b661530651996d40f1fc976add38782f64e"
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
