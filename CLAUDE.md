# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Homebrew tap repository for the Camunda Modeler Annotations Plugin. It contains a Ruby formula that installs a plugin/extension for Camunda Modeler on macOS.

**Repository URL**: https://github.com/marcinbien/homebrew-camunda-modeler-annotations-plugin

## Architecture

### Homebrew Formula Structure

The repository follows Homebrew tap conventions:
- `Formula/` directory contains the Ruby formula files
- `Formula/camunda-modeler-annotations-plugin.rb` is the main formula

### Installation Flow

The formula implements a two-stage installation process:

1. **install method**: Downloads and extracts the plugin to Homebrew's managed directory (`libexec`)
   - Handles both subdirectory and root-level extraction scenarios
   - Creates a marker file documenting the installation

2. **post_install method**: Runs outside Homebrew's sandbox to copy files to the user's home directory
   - Target location: `~/Library/Application Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin`
   - This is necessary because Camunda Modeler looks for plugins in the user's Application Support directory, not in Homebrew's Cellar

### Key Implementation Details

- The formula downloads a release ZIP from GitHub (currently v0.0.2)
- Files are first installed to `libexec` (Homebrew-managed location)
- In `post_install`, files are copied from `libexec` to the Camunda Modeler plugins directory
- The formula handles both nested and flat directory structures in the ZIP file
- Includes verbose logging (`ohai`) for debugging installation issues

## Common Commands

### Testing the Formula Locally

```bash
# Install the formula locally for testing
brew install --build-from-source Formula/camunda-modeler-annotations-plugin.rb

# Reinstall after making changes
brew reinstall --build-from-source Formula/camunda-modeler-annotations-plugin.rb

# Uninstall
brew uninstall camunda-modeler-annotations-plugin

# Run the formula's test
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

### Debugging Installation

```bash
# View installation logs
brew install -v camunda-modeler-annotations-plugin

# Check what's installed in libexec
ls -la $(brew --prefix camunda-modeler-annotations-plugin)/libexec

# Check the final plugin installation
ls -la ~/Library/Application\ Support/camunda-modeler/resources/plugins/camunda-modeler-annotations-plugin
```

## Implementation Notes

### macOS Permission Handling

The formula uses `ditto` instead of `cp` for copying files to `~/Library/Application Support` because:
- macOS applies extended attributes and security restrictions to Application Support directories
- `cp` fails with "Operation not permitted" even with `-Rf` flags
- `ditto` is a macOS-native tool that properly handles these restrictions

### Why Post-Install Hook?

Camunda Modeler looks for plugins in the user's Application Support directory, not in Homebrew's Cellar. The `post_install` hook runs outside Homebrew's sandbox, allowing writes to the user's home directory.
