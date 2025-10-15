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

    # Attempt automatic installation (may be blocked by macOS sandbox)
    begin
      system "mkdir", "-p", target
      system "rsync", "-a", "#{libexec}/", "#{target}/"
    rescue
      # Silently fail - user will see instructions in caveats
    end
  end

  def caveats
    installed = File.exist?(File.expand_path("~/Library/Application Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin/index.js"))

    if installed
      <<~EOS
        ✅ Plugin installed successfully!

        📝 Restart Camunda Modeler to load the plugin.
      EOS
    else
      <<~EOS
        📦 Plugin files are ready at: #{libexec}

        To complete installation, copy-paste this command:

          rsync -a "#{libexec}/" ~/Library/Application\\ Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin/

        Then restart Camunda Modeler to load the plugin.
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
