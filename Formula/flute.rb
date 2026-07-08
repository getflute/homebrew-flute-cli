class Flute < Formula
  desc "Cross-platform CLI for the Flute payments platform"
  homepage "https://github.com/getflute/flute-cli"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli/releases/download/v1.0.0/flute-aarch64-apple-darwin.tar.xz"
      sha256 "9d43344390128ea0a2fd7deb6a9d8dcc279ab23ecfbbd82f5ff4e515950eae79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli/releases/download/v1.0.0/flute-x86_64-apple-darwin.tar.xz"
      sha256 "f28129f8152b0219345b5fd952db363896d74a5d45cf6bb3073319cfa1ce0983"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli/releases/download/v1.0.0/flute-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7415afed2e309beedbc41c43c93c1a9dafb0d42d0af7264e8d4ef408766949d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli/releases/download/v1.0.0/flute-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3414bab10f256257f1fc32953c1528f45def85e59ca4e9843cc09c432e228913"
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
