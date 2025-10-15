class CamundaModelerExtension < Formula
  desc "Extensions/plugins for Camunda Modeler"
  homepage "https://github.com/marcinbien/camunda-modeler-annotations-plugin"
  url "https://github.com/marcinbien/camunda-modeler-annotations-plugin/releases/download/v0.0.2/camunda-modeler-annotations-plugin-v0.0.2.zip"
  sha256 "a1d688f67320a17ad3194cdad811eb266404d2b907d367a70e00a7c78a9a3de9"
  version "0.0.2"

  def install
    # The plugin directory path
    plugin_dir = "#{Dir.home}/Library/Application Support/camunda-modeler/resources/plugins"
    
    # Create the plugins directory if it doesn't exist
    FileUtils.mkdir_p(plugin_dir)
    
    # Copy all files from the extracted zip to the plugin directory
    # Adjust the path if your zip has a nested structure
    FileUtils.cp_r(Dir["*"], plugin_dir)
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