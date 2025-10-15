class CamundaModelerAnnotationsPlugin < Formula
  desc "Extensions/plugins for Camunda Modeler"
  homepage "https://github.com/marcinbien/camunda-modeler-annotations-plugin"
  url "https://github.com/marcinbien/camunda-modeler-annotations-plugin/releases/download/v0.0.2/camunda-modeler-annotations-plugin-v0.0.2.zip"
  sha256 "a1d688f67320a17ad3194cdad811eb266404d2b907d367a70e00a7c78a9a3de9"
  version "0.0.2"

def install
  target = File.expand_path("~/Library/Application Support/camunda-modeler/resources/plugins")
  mkdir_p target
  ohai "Creating plugin directory at #{target}"

  # Unzip the archive to buildpath
  system "unzip", "-q", cached_download, "-d", buildpath

  # The plugin folder inside the zip
  plugin_folder = Dir.glob("#{buildpath}/camunda-modeler-annotations-plugin/*").first
  plugin_root = File.dirname(plugin_folder)  # parent folder containing index.js

  ohai "Copying plugin folder: #{plugin_root}"
  cp_r plugin_root, target
end




  def caveats
    <<~EOS
      ✅ Plugin installed to:
         ~/Library/Application Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin

      You can restart Camunda Modeler to see it under the Plugins menu.
    EOS
  end
end