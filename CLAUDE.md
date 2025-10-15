# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Homebrew tap repository for the Camunda Modeler Annotations Plugin. It contains a Ruby formula that installs a plugin/extension for Camunda Modeler on macOS by placing files directly into the user's Application Support directory.

**Repository URL**: https://github.com/marcinbien/homebrew-camunda-modeler-annotations-plugin

## Architecture

### Homebrew Formula Structure

The repository follows Homebrew tap conventions:
- `Formula/` directory contains the Ruby formula files
- `Formula/camunda-modeler-annotations-plugin.rb` is the main formula

### Installation Flow

The formula uses a simplified single-stage installation:

1. Downloads the plugin ZIP from GitHub releases
2. Extracts the ZIP to `buildpath`
3. Locates the plugin folder within the extracted contents (handles nested directory structures)
4. Copies directly to: `~/Library/Application Support/camunda-modeler/resources/plugins/`

This approach installs directly to the user's Application Support directory because that's where Camunda Modeler looks for plugins (not in Homebrew's Cellar).

### Key Implementation Details

- Uses `cp_r` to recursively copy the plugin folder
- Creates the target directory with `mkdir_p` if it doesn't exist
- Handles nested directory structures in the ZIP file via `Dir.glob` pattern matching
- Includes error handling with `odie` if the plugin folder structure is unexpected
- Uses `ohai` for verbose logging to help debug installation issues

## Common Commands

### Testing the Formula Locally

```bash
# Install the formula locally for testing
brew install --build-from-source Formula/camunda-modeler-annotations-plugin.rb

# Reinstall after making changes
brew reinstall --build-from-source Formula/camunda-modeler-annotations-plugin.rb

# Uninstall
brew uninstall camunda-modeler-annotations-plugin

# Run the formula's test (if defined)
brew test camunda-modeler-annotations-plugin
```

### Updating the Formula for New Releases

When releasing a new version:

1. Update the `url` with the new release download link
2. Update the `version` field
3. Calculate and update the `sha256` hash:
   ```bash
   shasum -a 256 /path/to/downloaded/release.zip
   ```
4. Test the installation locally before pushing

### Debugging Installation

```bash
# View installation logs with verbose output
brew install -v camunda-modeler-annotations-plugin

# Check the final plugin installation
ls -la ~/Library/Application\ Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin
```

## Implementation Notes

### Direct Installation Approach

Unlike typical Homebrew formulas that install to the Cellar, this formula installs directly to the user's Application Support directory. This is necessary because:
- Camunda Modeler looks for plugins in `~/Library/Application Support/camunda-modeler/resources/plugins/`
- The plugin must be in this exact location to be discovered by Camunda Modeler
- Symlinking from the Cellar would not work as the application expects a specific directory structure

### Evolution History

The formula went through several iterations to handle macOS permission issues:
- Earlier versions used a two-stage process with `post_install` hooks
- Earlier versions attempted to use `ditto` to handle macOS extended attributes
- Current version (as of commits #10-#13) uses simplified `cp_r` with direct installation
- Key lesson: The nested directory structure in the ZIP required careful glob pattern matching to locate the actual plugin folder

### ZIP File Structure Expectations

The formula expects the downloaded ZIP to contain:
```
camunda-modeler-annotations-plugin/
  camunda-modeler-annotations-plugin/
    index.js
    [other plugin files]
```

The `Dir.glob` pattern matches this nested structure. If the ZIP structure changes, update the glob pattern in the `install` method.
