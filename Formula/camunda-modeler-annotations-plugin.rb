class CamundaModelerAnnotationsPlugin < Formula
  desc "Annotations plugin for Camunda Modeler"
  homepage "https://github.com/marcinbien/camunda-modeler-annotations-plugin"
  url "https://github.com/marcinbien/camunda-modeler-annotations-plugin/releases/download/v0.0.2/camunda-modeler-annotations-plugin-v0.0.2.zip"
  sha256 "a1d688f67320a17ad3194cdad811eb266404d2b907d367a70e00a7c78a9a3de9"
  version "0.0.2"

  def install
    # Extract the ZIP file to buildpath
    system "unzip", "-q", cached_download, "-d", buildpath

    # The extracted plugin folder
    plugin_folder = "#{buildpath}/camunda-modeler-annotations-plugin"

    # Verify the plugin folder exists
    unless File.directory?(plugin_folder)
      odie "Could not find plugin folder: #{plugin_folder}"
    end

    # Install to libexec (Homebrew-managed directory)
    libexec.install Dir["#{plugin_folder}/*"]
  end

  def post_install
    # This runs outside the sandbox, so we can write to the user's home directory
    # Use ENV["HOME"] to ensure we get the real home directory
    target_dir = "#{ENV["HOME"]}/Library/Application Support/camunda-modeler/resources/plugins"
    target = "#{target_dir}/camunda-modeler-annotations-plugin"

    # Create parent directory first
    unless File.directory?(target_dir)
      ohai "Creating plugins directory: #{target_dir}"
      FileUtils.mkdir_p(target_dir)
    end

    # Use ditto to copy files - it handles macOS permissions and extended attributes properly
    ohai "Installing plugin to: #{target}"

    # Remove existing installation if present
    FileUtils.rm_rf(target) if File.exist?(target)

    # Copy using ditto
    system "ditto", libexec.to_s, target

    unless File.exist?("#{target}/index.js")
      opoo "Plugin installation may have failed - index.js not found"
    end

    ohai "✅ Plugin installed successfully"
  end

  def caveats
    <<~EOS
      ✅ Camunda Modeler Annotations Plugin installed to:
         ~/Library/Application Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin

      📝 Restart Camunda Modeler to load the plugin.
      The plugin will appear in the Plugins menu.
    EOS
  end

  test do
    # Verify the plugin was installed to the correct location
    plugin_dir = File.expand_path("~/Library/Application Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin")
    assert File.directory?(plugin_dir), "Plugin directory not found"
    assert File.exist?("#{plugin_dir}/index.js"), "index.js not found"
    assert File.exist?("#{plugin_dir}/annotations-plugin.js"), "annotations-plugin.js not found"
  end
end
