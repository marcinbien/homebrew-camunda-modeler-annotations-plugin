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

    # Create a helper script for installation
    (bin/"camunda-modeler-install-plugin").write <<~EOS
      #!/bin/bash
      set -e
      TARGET="$HOME/Library/Application Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin"
      echo "Installing Camunda Modeler Annotations Plugin..."
      ditto "#{libexec}" "$TARGET"
      echo "✅ Plugin installed to: $TARGET"
      echo "📝 Restart Camunda Modeler to load the plugin."
    EOS
  end

  def caveats
    <<~EOS
      To complete the installation, run:

        camunda-modeler-install-plugin

      This will copy the plugin to Camunda Modeler's plugins directory.
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
