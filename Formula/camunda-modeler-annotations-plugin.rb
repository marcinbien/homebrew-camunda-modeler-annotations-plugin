class CamundaModelerAnnotationsPlugin < Formula
  desc "Extensions/plugins for Camunda Modeler"
  homepage "https://github.com/marcinbien/camunda-modeler-annotations-plugin"
  url "https://github.com/marcinbien/camunda-modeler-annotations-plugin/releases/download/v0.0.2/camunda-modeler-annotations-plugin-v0.0.2.zip"
  sha256 "a1d688f67320a17ad3194cdad811eb266404d2b907d367a70e00a7c78a9a3de9"
  version "0.0.2"

def install
  target = File.expand_path("~/Library/Application Support/camunda-modeler/resources/plugins")

  # Ensure target directory exists
  ohai "Creating plugin directory at #{target}"
  mkdir_p target

  # Find the extracted directory
  extracted_dir = Dir["#{buildpath}/camunda-modeler-annotations-plugin*"].first
  ohai "Using extracted directory: #{extracted_dir}"

  # Copy it over
  cp_r extracted_dir, target
end

  def caveats
    <<~EOS
      ✅ Plugin installed to:
         ~/Library/Application Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin

      You can restart Camunda Modeler to see it under the Plugins menu.
    EOS
  end
end