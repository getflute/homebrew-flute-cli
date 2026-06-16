class Flute < Formula
  desc "Cross-platform CLI for the Flute payments platform"
  homepage "https://github.com/getflute/flute-cli"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli/releases/download/v0.1.4/flute-aarch64-apple-darwin.tar.xz"
      sha256 "abc978233e00d738915c62e68784882ba211735775c7e29a9fc1e51bed48142a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli/releases/download/v0.1.4/flute-x86_64-apple-darwin.tar.xz"
      sha256 "3e85abfc3e85cdf9133c4c574fc16b68914d007c37dbd022406cdd64382cf4f1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli/releases/download/v0.1.4/flute-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "18ae57f2c0ae2670cae757fc5d61499d6f2db6f7444ccf8b304d042f235c7d9e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli/releases/download/v0.1.4/flute-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ff345cdb56506b430e0688ddbad7a545975f16200d352fbfe4269f95f05daec7"
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
