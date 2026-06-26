class Deepfind < Formula
  desc "Fast local file search for macOS — trigram index + daemon + CLI"
  homepage "https://github.com/nadav-cheung/DeepFinder"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nadav-cheung/DeepFinder/releases/download/v0.1.4/deepfind-aarch64-apple-darwin.tar.xz"
      sha256 "fe25e70b7158f12a9a02be400b4f76c05bd6221ded116269048173cccfc4bbd3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nadav-cheung/DeepFinder/releases/download/v0.1.4/deepfind-x86_64-apple-darwin.tar.xz"
      sha256 "8709ad09e3dcfd1074b4cf6a04bf6b0ecd70a0719b75aeaa7c9e4e581857c675"
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
