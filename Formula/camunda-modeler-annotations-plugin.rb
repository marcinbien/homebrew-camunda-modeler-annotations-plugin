class CamundaModelerAnnotationsPlugin < Formula
  desc "Extensions/plugins for Camunda Modeler"
  homepage "https://github.com/marcinbien/camunda-modeler-annotations-plugin"
  url "https://github.com/marcinbien/camunda-modeler-annotations-plugin/releases/download/v0.0.2/camunda-modeler-annotations-plugin-v0.0.2.zip"
  sha256 "a1d688f67320a17ad3194cdad811eb266404d2b907d367a70e00a7c78a9a3de9"
  version "0.0.2"

  def install
    # Check if files are in a subdirectory or at root level
    if File.directory?("camunda-modeler-annotations-plugin")
      # Files are in a subdirectory, install contents of that directory
      libexec.install Dir["camunda-modeler-annotations-plugin/*"]
    else
      # Files are at root level
      libexec.install Dir["*"]
    end

    # Create a marker file in Homebrew's prefix
    (prefix/"installed.txt").write <<~EOS
      Camunda Modeler Annotations Plugin
      Files stored in: #{libexec}
      Will be linked to user directory in post_install
    EOS
  end

  def post_install
    # This runs outside the sandbox, so we can write to the user's home directory
    real_home = ENV["HOME"]
    plugin_dir = "#{real_home}/Library/Application Support/camunda-modeler/resources/plugins"
    target_dir = "#{plugin_dir}/camunda-modeler-annotations-plugin"

    ohai "Post-install: Installing to #{target_dir}"
    ohai "libexec path: #{libexec}"

    # Create the plugins directory if it doesn't exist
    # Check first to avoid permission issues with mkdir on existing dirs
    unless Dir.exist?(plugin_dir)
      system "mkdir", "-p", plugin_dir or odie "Failed to create plugin directory: #{plugin_dir}"
    end

    # Create target directory if it doesn't exist
    unless Dir.exist?(target_dir)
      system "mkdir", "-p", target_dir or odie "Failed to create target directory: #{target_dir}"
    end

    # Copy files from Cellar to the plugin directory, overwriting if exists
    # Using -f flag to force overwrite without prompting
    ohai "Copying plugin files..."
    system "cp", "-Rf", "#{libexec}/.", target_dir or odie "Failed to copy files to #{target_dir}"

    # Verify installation
    if Dir.exist?(target_dir) && !Dir.empty?(target_dir)
      ohai "✓ Installation successful!"
      ohai "Plugin files:"
      system "ls", "-la", target_dir
    else
      odie "Installation failed - target directory is empty"
    end
  end

  test do
    # Check if the plugin directory exists
    assert_predicate Pathname.new("#{Dir.home}/Library/Application Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin"), :exist?
  end
end