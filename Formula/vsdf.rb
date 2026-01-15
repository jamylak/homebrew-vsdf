class Vsdf < Formula
  desc "Vulkan SDF Renderer + Video Recorder + Hot Reloader"
  homepage "https://github.com/jamylak/vsdf"
  # Replace this with the latest version tag from your release
  version "0.2.0"
  license "GPL-3.0-only"

  on_macos do
    depends_on "molten-vk"
    if Hardware::CPU.intel?
      url "https://github.com/jamylak/vsdf/releases/download/v#{version}/vsdf-macos-x86_64.tar.gz"
      # Replace this with the SHA256 checksum of the x86_64 macOS release tarball
      sha256 "24afb799ec3e37034c45e98c652855680599337caec49a3f264a8abe97ea6cc9"
    elsif Hardware::CPU.arm?
      url "https://github.com/jamylak/vsdf/releases/download/v#{version}/vsdf-macos-arm64.tar.gz"
      # Replace this with the SHA256 checksum of the arm64 macOS release tarball
      sha256 "762f19bd7e47107e44acfde01d397d47d731ccc69de7e09278e833ab3b254ad4"
    end
  end

  on_linux do
    depends_on "vulkan-loader"
    if Hardware::CPU.intel?
      url "https://github.com/jamylak/vsdf/releases/download/v#{version}/vsdf-linux-x86_64.tar.gz"
      # Replace this with the SHA256 checksum of the Linux release tarball
      sha256 "5a02702234e3f7b4434e6089142c1f0b1daf0eb47607cecf728506ce5c1b591c"
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
      void main() {
        gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);
      }
    EOS
    system bin/"vsdf", "--toy", testpath/"test.frag", "--frames", "1", "--headless"
  end
end
