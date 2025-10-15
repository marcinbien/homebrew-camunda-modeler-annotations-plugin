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

    # Create an installation marker file with instructions
    (prefix/"INSTALL_INSTRUCTIONS.txt").write <<~EOS
      This plugin has been downloaded to:
      #{libexec}

      To complete installation, run:
      cp -r "#{libexec}" "$HOME/Library/Application Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin"
    EOS
  end

  def post_install
    target_base = File.expand_path("~/Library/Application Support/camunda-modeler/resources/plugins")
    target = "#{target_base}/camunda-modeler-annotations-plugin"

    # Try to install, but don't fail if it doesn't work
    begin
      # Create a temporary shell script and execute it
      # This runs the command in a separate process outside Ruby's context
      script = Tempfile.new(["install-plugin", ".sh"])
      script.write <<~SCRIPT
        #!/bin/bash
        mkdir -p "#{target_base}"
        rm -rf "#{target}"
        cp -r "#{libexec}" "#{target}"
        if [ -f "#{target}/index.js" ]; then
          echo "✅ Plugin installed successfully"
          exit 0
        else
          exit 1
        fi
      SCRIPT
      script.close
      FileUtils.chmod(0755, script.path)

      system script.path
      script.unlink
    rescue => e
      opoo "Automatic installation failed. Please see caveats for manual installation."
    end
  end

  def caveats
    target = "~/Library/Application Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin"
    installed = File.exist?(File.expand_path("~/Library/Application Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin/index.js"))

    if installed
      <<~EOS
        ✅ Camunda Modeler Annotations Plugin has been installed to:
           #{target}

        📝 Restart Camunda Modeler to load the plugin.
      EOS
    else
      <<~EOS
        ⚠️  Automatic installation was blocked by macOS permissions.

        To complete installation, run this command:

          mkdir -p "~/Library/Application Support/camunda-modeler/resources/plugins" && cp -r "#{libexec}" "~/Library/Application Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin"

        Then restart Camunda Modeler.
      EOS
    end
  end

  test do
    # Verify the plugin was installed to the correct location
    plugin_dir = File.expand_path("~/Library/Application Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin")
    assert File.directory?(plugin_dir), "Plugin directory not found"
    assert File.exist?("#{plugin_dir}/index.js"), "index.js not found"
    assert File.exist?("#{plugin_dir}/annotations-plugin.js"), "annotations-plugin.js not found"
  end
end
