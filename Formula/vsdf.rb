class Vsdf < Formula
  desc "Vulkan SDF Renderer + Video Recorder + Hot Reloader"
  homepage "https://github.com/jamylak/vsdf"
  # Replace this with the latest version tag from your release
  version "0.2.5"
  license "GPL-3.0-only"

  on_macos do
    depends_on "molten-vk"
    if Hardware::CPU.intel?
      url "https://github.com/jamylak/vsdf/releases/download/v#{version}/vsdf-macos-x86_64.tar.gz"
      # Replace this with the SHA256 checksum of the x86_64 macOS release tarball
      sha256 "6d2d8c45d75733453247fd284b7dc423e8643144d4f69c834a753e53c8c0a992"
    elsif Hardware::CPU.arm?
      url "https://github.com/jamylak/vsdf/releases/download/v#{version}/vsdf-macos-arm64.tar.gz"
      # Replace this with the SHA256 checksum of the arm64 macOS release tarball
      sha256 "638af8cf6262ae7c2dd1fc359795d24177e7bd3c7f3975061a9acc30cd51c4fe"
    end
  end

  on_linux do
    depends_on "vulkan-loader"
    if Hardware::CPU.intel?
      url "https://github.com/jamylak/vsdf/releases/download/v#{version}/vsdf-linux-x86_64.tar.gz"
      # Replace this with the SHA256 checksum of the Linux release tarball
      sha256 "d220a405a68fe42f90abfd7807919533268de8e6248a4c5f9e3ee3c895838520"
    end
  end

  def install
    # The release archives contain the executable, libraries, and shaders.
    # We install them into the appropriate directories.
    libexec.install "vsdf"
    libexec.install "libs"
    pkgshare.install "shaders"

    # Create a symlink in the bin directory to the executable in libexec.
    # This is the standard Homebrew practice for binaries with bundled libraries.
    bin.install_symlink libexec/"vsdf"
  end

  test do
    # A simple test to check if the binary runs and shows the version.
    system bin/"vsdf", "--version"

    # A more complex test that requires a running Vulkan instance.
    # This will test a 1-frame headless render.
    # It requires the shaders, which we installed to pkgshare.
    (testpath/"test.frag").write <<~EOS
      void mainImage( out vec4 fragColor, in vec2 fragCoord ){
        fragColor = vec4(1.0, 0.0, 0.0, 1.0); // Red
      }
    EOS
    system bin/"vsdf", "--toy", testpath/"test.frag", "--frames", "1", "--headless"
  end
end
