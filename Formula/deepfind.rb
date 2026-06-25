class Deepfind < Formula
  desc "Fast local file search for macOS — trigram index + daemon + CLI"
  homepage "https://github.com/nadav-cheung/DeepFinder"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nadav-cheung/DeepFinder/releases/download/v0.1.0/deepfind-aarch64-apple-darwin.tar.xz"
      sha256 "27d062ce0c146fcc8f3fd24a696f451d375b3d9c7595c372e3da18228878780e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nadav-cheung/DeepFinder/releases/download/v0.1.0/deepfind-x86_64-apple-darwin.tar.xz"
      sha256 "02b97fc7b5a06dac70582f73e92f25ee96ff9f2a878977ea7133927095cd0b1b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
    bin.install "deepfind" if OS.mac? && Hardware::CPU.arm?
    bin.install "deepfind" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
