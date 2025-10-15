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
    # Install directly to the Camunda Modeler plugins directory
    # Using Ruby's FileUtils instead of system commands to avoid sandbox issues
    target_base = "#{Dir.home}/Library/Application Support/camunda-modeler/resources/plugins"
    target = "#{target_base}/camunda-modeler-annotations-plugin"

    # Create the plugins directory if needed
    FileUtils.mkdir_p(target_base) unless File.directory?(target_base)

    # Remove existing installation if present
    FileUtils.rm_rf(target) if File.exist?(target)

    # Copy files from libexec to target
    FileUtils.cp_r(libexec, target)

    ohai "✅ Plugin installed to: #{target}"
  end

  def caveats
    <<~EOS
      ✅ Camunda Modeler Annotations Plugin has been installed.

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
