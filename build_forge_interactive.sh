#!/usr/bin/env bash
#
# KorGE Forge Interactive Build Script
# This script provides an interactive menu to build KorGE Forge
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Default values
BUILD_PLATFORM="current"
JAVA_HOME_PATH=""
INCREMENTAL_BUILD="false"

# Print colored header
print_header() {
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║           KorGE Forge Interactive Build Script             ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Print info message
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Print success message
success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Print warning message
warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Print error message
error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect Java installation
detect_java() {
    info "Detecting Java installation..."
    
    if [ -n "$JAVA_HOME" ]; then
        if [ -x "$JAVA_HOME/bin/java" ]; then
            JAVA_VERSION=$("$JAVA_HOME/bin/java" -version 2>&1 | head -n 1 | cut -d'"' -f2)
            success "Found Java at JAVA_HOME: $JAVA_HOME (Version: $JAVA_VERSION)"
            JAVA_HOME_PATH="$JAVA_HOME"
            return 0
        fi
    fi
    
    if command -v java &> /dev/null; then
        JAVA_PATH=$(which java)
        JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
        success "Found Java in PATH: $JAVA_PATH (Version: $JAVA_VERSION)"
        # Try to determine JAVA_HOME from java path
        JAVA_REAL_PATH=$(readlink -f "$JAVA_PATH" 2>/dev/null || echo "$JAVA_PATH")
        JAVA_BIN_DIR=$(dirname "$JAVA_REAL_PATH")
        JAVA_HOME_PATH=$(dirname "$JAVA_BIN_DIR")
        return 0
    fi
    
    error "Java not found. Please install JDK 21 or set JAVA_HOME."
    return 1
}

# Platform selection menu
select_platform() {
    echo -e "\n${BOLD}Select Build Platform:${NC}"
    echo "  1) Current platform only (faster)"
    echo "  2) All platforms (Windows, macOS, Linux)"
    echo ""
    
    while true; do
        read -p "Enter choice [1-2]: " choice
        case $choice in
            1)
                BUILD_PLATFORM="current"
                info "Selected: Build for current platform only"
                break
                ;;
            2)
                BUILD_PLATFORM="all"
                info "Selected: Build for all platforms"
                break
                ;;
            *)
                warn "Invalid choice. Please enter 1 or 2."
                ;;
        esac
    done
}

# Incremental build option
select_incremental() {
    echo -e "\n${BOLD}Incremental Build:${NC}"
    echo "  1) Full build (clean)"
    echo "  2) Incremental build (faster, may have issues)"
    echo ""
    
    while true; do
        read -p "Enter choice [1-2]: " choice
        case $choice in
            1)
                INCREMENTAL_BUILD="false"
                info "Selected: Full build"
                break
                ;;
            2)
                INCREMENTAL_BUILD="true"
                info "Selected: Incremental build"
                break
                ;;
            *)
                warn "Invalid choice. Please enter 1 or 2."
                ;;
        esac
    done
}

# Confirmation prompt
confirm_build() {
    echo -e "\n${BOLD}Build Configuration Summary:${NC}"
    echo "  • Platform: $BUILD_PLATFORM"
    echo "  • Incremental: $INCREMENTAL_BUILD"
    echo "  • Java Home: $JAVA_HOME_PATH"
    echo ""
    
    while true; do
        read -p "Proceed with build? [y/n]: " yn
        case $yn in
            [Yy]* )
                return 0
                ;;
            [Nn]* )
                info "Build cancelled by user."
                exit 0
                ;;
            * )
                warn "Please answer y or n."
                ;;
        esac
    done
}

# Run the build
run_build() {
    echo -e "\n${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    info "Starting KorGE Forge build..."
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}\n"
    
    # Set JAVA_HOME
    export JAVA_HOME="$JAVA_HOME_PATH"
    export PATH="$JAVA_HOME/bin:$PATH"
    
    # Build arguments
    BUILD_ARGS=""
    
    if [ "$BUILD_PLATFORM" = "current" ]; then
        BUILD_ARGS="$BUILD_ARGS -Dintellij.build.target.os=current"
    fi
    
    if [ "$INCREMENTAL_BUILD" = "true" ]; then
        BUILD_ARGS="$BUILD_ARGS -Dintellij.build.incremental.compilation=true"
    fi
    
    info "Running: ./installers.cmd $BUILD_ARGS"
    echo ""
    
    # Run the build (using eval to properly handle empty BUILD_ARGS)
    if [ -n "$BUILD_ARGS" ]; then
        eval "./installers.cmd $BUILD_ARGS"
    else
        ./installers.cmd
    fi
    
    echo ""
    success "Build completed!"
    echo -e "\n${GREEN}Find the built KorGE Forge in out/korgeforge/artifacts/${NC}"
    echo -e "${GREEN}Extract and run with ./korge.sh in bin/${NC}\n"
}

# Main function
main() {
    print_header
    
    # Check we're in the right directory
    if [ ! -f "installers.cmd" ]; then
        error "This script must be run from the korge-forge root directory."
        exit 1
    fi
    
    # Detect Java
    if ! detect_java; then
        exit 1
    fi
    
    # Interactive menu
    select_platform
    select_incremental
    
    # Confirm and build
    confirm_build
    run_build
}

# Run main
main "$@"
