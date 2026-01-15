class Vsdf < Formula
  desc "SDF renderer for music shaders"
  homepage "https://github.com/jamylak/vsdf"
  # Replace this with the latest version tag from your release
  version "v0.1.4"
  license "GPL"

  # These dependencies will be automatically installed by Homebrew if not present
  depends_on "molten-vk" => :on_macos
  depends_on "vulkan-loader" => :on_linux

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/jamylak/vsdf/releases/download/v#{version}/vsdf-macos-x86_64.tar.gz"
      # Replace this with the SHA256 checksum of the x86_64 macOS release tarball
      sha256 "sha256:601ea94c231ce11a5c23a6cb18f6197ee34f3939f4da8d645e9689183fcf5d8e"
    elsif Hardware::CPU.arm?
      url "https://github.com/jamylak/vsdf/releases/download/v#{version}/vsdf-macos-arm64.tar.gz"
      # Replace this with the SHA256 checksum of the arm64 macOS release tarball
      sha256 "sha256:40412be090f8985ccce4f45c24658b48223b5c52a54aae3f22e609610dfbff3b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/jamylak/vsdf/releases/download/v#{version}/vsdf-linux-x86_64.tar.gz"
      # Replace this with the SHA256 checksum of the Linux release tarball
      sha256 "sha256:573a9823c0f4a6d4a6ff7904a852b598c85145979462a283857e5e6205eb9771"
    end
  end

  def install
    # The release archives contain a directory named 'macos' or 'linux'.
    # We'll install all the contents into libexec to keep them together.
    on_macos do
      libexec.install "macos/vsdf"
      libexec.install "macos/libs"
      pkgshare.install "macos/shaders"
    end
    on_linux do
      libexec.install "linux/vsdf"
      libexec.install "linux/libs"
      pkgshare.install "linux/shaders"
    end

    # Create a symlink in the bin directory to the executable in libexec.
    # This is the standard Homebrew practice for binaries with bundled libraries.
    bin.install_symlink libexec/"vsdf"
  end

  test do
    # A simple test to check if the binary runs and shows the version.
    system "#{bin}/vsdf", "--version"

    # A more complex test that requires a running Vulkan instance.
    # This will test a 1-frame headless render.
    # It requires the shaders, which we installed to pkgshare.
    (testpath/"test.frag").write <<~EOS
      void main() {
        gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);
      }
    EOS
    system "#{bin}/vsdf", "--toy", testpath/"test.frag", "--frames", "1", "--headless"
  end
end
