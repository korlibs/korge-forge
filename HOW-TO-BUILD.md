# How to build KorGE Forge?

1. Clone korge-forge plugin: git clone https://github.com/korlibs/korge-forge-plugin.git
2. Run `./gradlew doForgeRelease` in korge-forge-plugin
3. Execute `./build_forge.sh`

The build script provides an interactive interface with:
- Automatic Java detection
- Platform selection (current platform or all platforms)
- Incremental build option
- Colored output for better visibility