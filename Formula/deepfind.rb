class Deepfind < Formula
  desc "Fast local file search for macOS — trigram index + daemon + CLI"
  homepage "https://github.com/nadav-cheung/DeepFinder"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nadav-cheung/DeepFinder/releases/download/v0.1.6/deepfind-aarch64-apple-darwin.tar.xz"
      sha256 "97e796a3b15eaf44b6846f24240c32abac0cc69db2e3dbdfc4cc271bdd3ed369"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nadav-cheung/DeepFinder/releases/download/v0.1.6/deepfind-x86_64-apple-darwin.tar.xz"
      sha256 "c03057156339d567b8867ca5de73518447a176addbb2e1b8ad3f6ded7b25277e"
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
