# How to build KorGE Forge?

## Quick Build
1. Clone korge-forge plugin: git clone https://github.com/korlibs/korge-forge-plugin.git
2. Run `./gradlew doForgeRelease` in korge-forge-plugin
3. Execute `./build_forge.sh`

## Interactive Build (Recommended)
For a more user-friendly experience with platform selection and build options:
```bash
./build_forge_interactive.sh
```

This interactive script provides:
- Automatic Java detection
- Platform selection (current platform or all platforms)
- Incremental build option
- Colored output for better visibility