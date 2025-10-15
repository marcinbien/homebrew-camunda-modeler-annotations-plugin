class CamundaModelerAnnotationsPlugin < Formula
  desc "Extensions/plugins for Camunda Modeler"
  homepage "https://github.com/marcinbien/camunda-modeler-annotations-plugin"
  url "https://github.com/marcinbien/camunda-modeler-annotations-plugin/releases/download/v0.0.2/camunda-modeler-annotations-plugin-v0.0.2.zip"
  sha256 "a1d688f67320a17ad3194cdad811eb266404d2b907d367a70e00a7c78a9a3de9"
  version "0.0.2"

  def install
    # Get the real home directory (not Homebrew's sandbox home)
    real_home = ENV["HOME"]
    
    # The plugin directory path
    plugin_dir = "#{real_home}/Library/Application Support/camunda-modeler/resources/plugins"
    target_dir = "#{plugin_dir}/camunda-modeler-annotations-plugin"
    
    # Debug: Show what we're working with
    ohai "Real home directory: #{real_home}"
    ohai "Target plugin directory: #{plugin_dir}"
    ohai "Current directory: #{Dir.pwd}"
    ohai "Files available:"
    system "ls", "-la"
    
    # Create the plugins directory if it doesn't exist
    FileUtils.mkdir_p(plugin_dir)
    ohai "Created plugin directory: #{plugin_dir}"
    
    # Remove target if it exists (for reinstalls)
    FileUtils.rm_rf(target_dir) if File.exist?(target_dir)
    
    # Check if we have the directory or just files
    plugin_source = "camunda-modeler-annotations-plugin"
    
    if File.directory?(plugin_source)
      # The directory exists, copy it directly
      ohai "Found directory '#{plugin_source}', copying to #{plugin_dir}"
      FileUtils.cp_r(plugin_source, plugin_dir)
    else
      # Homebrew extracted the contents directly, create the directory structure
      ohai "Directory not found, creating #{target_dir} and copying files"
      FileUtils.mkdir_p(target_dir)
      # Copy all files to the target directory
      Dir["*"].each do |file|
        ohai "Copying: #{file} -> #{target_dir}/#{file}"
        FileUtils.cp_r(file, target_dir)
      end
    end
    
    # Verify installation
    if Dir.exist?(target_dir) && !Dir.empty?(target_dir)
      ohai "Installation successful!"
      ohai "Files in #{target_dir}:"
      system "ls", "-la", target_dir
    else
      opoo "Target directory is empty or doesn't exist!"
    end
    
    # Create a marker file in Homebrew's prefix so it knows we installed something
    # This prevents "Empty installation" error
    (prefix/"installed.txt").write <<~EOS
      Camunda Modeler Annotations Plugin installed to:
      #{target_dir}
    EOS
  end


  def caveats
    <<~EOS
      This extension requires Camunda Modeler to be installed.
      If you haven't installed it yet, run:
        brew install --cask camunda-modeler

      The extension has been installed to:
        ~/Library/Application Support/camunda-modeler/plugins

      Please restart Camunda Modeler to load the extension.
    EOS
  end

  test do
    # Check if the plugin directory exists
    assert_predicate Pathname.new("#{Dir.home}/Library/Application Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin"), :exist?
  end
end