#!/bin/bash
################################################################################
# WilderedOS Build Script
# Main build orchestrator for creating WilderedOS ISO images
################################################################################

set -e  # Exit on error
set -u  # Exit on undefined variable

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source configuration
source "$SCRIPT_DIR/config/default.conf"
[[ -f "$SCRIPT_DIR/config/local.conf" ]] && source "$SCRIPT_DIR/config/local.conf"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

################################################################################
# Helper Functions
################################################################################

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $*"
}

log_error() {
    echo -e "${RED}[✗]${NC} $*" >&2
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $*"
}

show_usage() {
    cat << EOF
Usage: $0 [EDITION] [OPTIONS]

Build WilderedOS ISO image for the specified edition.

EDITIONS:
    base        Minimal installation with core components only
    standard    Full featured system with sidebar and Smart Storage
    test        Standard + Wine for Windows application support
    full        Complete installation with all presets

OPTIONS:
    --help, -h              Show this help message
    --clean                 Clean build directories before building
    --incremental           Use cached components for faster builds
    --compression=LEVEL     Set squashfs compression level (1-9, default: 9)
    --arch=ARCH            Architecture (amd64 or i386, default: amd64)
    --work-dir=PATH        Use alternative work directory
    --output-dir=PATH      Set output directory for ISO
    --verbose, -v          Enable verbose output
    --debug                Enable debug mode (keeps intermediate files)
    --skip-checksums       Skip checksum generation (faster)
    --no-cleanup           Don't clean up temporary files after build
    --extra-packages=PKGS  Comma-separated list of additional packages

EXAMPLES:
    # Build Base Edition with defaults
    sudo $0 base

    # Build Standard Edition with verbose output
    sudo $0 standard --verbose

    # Build with custom packages and faster compression
    sudo $0 standard --compression=3 --extra-packages="htop,ncdu"

    # Incremental build (reuses cache)
    sudo $0 standard --incremental

EOF
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

check_dependencies() {
    local missing=0
    local deps=(
        "debootstrap"
        "mksquashfs"
        "xorriso"
        "grub-mkrescue"
    )

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            log_error "Missing dependency: $dep"
            missing=1
        fi
    done

    if [[ $missing -eq 1 ]]; then
        log_error "Please install missing dependencies:"
        log_error "  sudo apt-get install debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amd64-bin"
        exit 1
    fi
}

setup_directories() {
    log "Setting up build directories..."
    
    mkdir -p "$WORK_DIR"
    mkdir -p "$CHROOT_DIR"
    mkdir -p "$IMAGE_DIR"
    mkdir -p "$OUTPUT_DIR"
    mkdir -p "$CACHE_DIR"
    mkdir -p "$LOG_DIR"
    
    log_success "Directories created"
}

cleanup() {
    if [[ "$NO_CLEANUP" == "false" ]]; then
        log "Cleaning up temporary files..."
        
        # Unmount any mounted filesystems
        if mountpoint -q "$CHROOT_DIR/proc" 2>/dev/null; then
            umount "$CHROOT_DIR/proc" || true
        fi
        if mountpoint -q "$CHROOT_DIR/sys" 2>/dev/null; then
            umount "$CHROOT_DIR/sys" || true
        fi
        if mountpoint -q "$CHROOT_DIR/dev" 2>/dev/null; then
            umount "$CHROOT_DIR/dev" || true
        fi
        
        # Remove work directory if not in debug mode
        if [[ "$DEBUG" == "false" ]]; then
            rm -rf "$WORK_DIR"
        fi
        
        log_success "Cleanup complete"
    else
        log_warning "Skipping cleanup (--no-cleanup specified)"
    fi
}

parse_arguments() {
    # Default values
    EDITION=""
    CLEAN=false
    INCREMENTAL=false
    COMPRESSION_LEVEL=9
    ARCH="amd64"
    VERBOSE=false
    DEBUG=false
    SKIP_CHECKSUMS=false
    NO_CLEANUP=false
    EXTRA_PACKAGES=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            base|standard|test|full)
                EDITION="$1"
                shift
                ;;
            --help|-h)
                show_usage
                exit 0
                ;;
            --clean)
                CLEAN=true
                shift
                ;;
            --incremental)
                INCREMENTAL=true
                shift
                ;;
            --compression=*)
                COMPRESSION_LEVEL="${1#*=}"
                shift
                ;;
            --arch=*)
                ARCH="${1#*=}"
                shift
                ;;
            --work-dir=*)
                WORK_DIR="${1#*=}"
                shift
                ;;
            --output-dir=*)
                OUTPUT_DIR="${1#*=}"
                shift
                ;;
            --verbose|-v)
                VERBOSE=true
                shift
                ;;
            --debug)
                DEBUG=true
                NO_CLEANUP=true
                shift
                ;;
            --skip-checksums)
                SKIP_CHECKSUMS=true
                shift
                ;;
            --no-cleanup)
                NO_CLEANUP=true
                shift
                ;;
            --extra-packages=*)
                EXTRA_PACKAGES="${1#*=}"
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Validate edition
    if [[ -z "$EDITION" ]]; then
        log_error "No edition specified"
        show_usage
        exit 1
    fi
    
    # Load edition-specific configuration
    if [[ -f "$SCRIPT_DIR/config/$EDITION.conf" ]]; then
        source "$SCRIPT_DIR/config/$EDITION.conf"
    else
        log_error "Unknown edition: $EDITION"
        exit 1
    fi
    
    # Set derived paths
    CHROOT_DIR="$WORK_DIR/chroot"
    IMAGE_DIR="$WORK_DIR/image"
    CACHE_DIR="$WORK_DIR/cache"
    LOG_DIR="$WORK_DIR/logs"
    
    # Export for sub-scripts
    export EDITION ARCH COMPRESSION_LEVEL VERBOSE DEBUG
    export CHROOT_DIR IMAGE_DIR CACHE_DIR OUTPUT_DIR
}

################################################################################
# Build Phases
################################################################################

phase_bootstrap() {
    log "Phase 1: Bootstrap base system"
    
    if [[ "$INCREMENTAL" == "true" ]] && [[ -d "$CHROOT_DIR/usr" ]]; then
        log_warning "Using cached bootstrap (--incremental)"
        return 0
    fi
    
    "$SCRIPT_DIR/bootstrap.sh" || {
        log_error "Bootstrap phase failed"
        exit 1
    }
    
    log_success "Bootstrap complete"
}

phase_customize() {
    log "Phase 2: Customize system"
    
    "$SCRIPT_DIR/customize.sh" || {
        log_error "Customization phase failed"
        exit 1
    }
    
    log_success "Customization complete"
}

phase_compress() {
    log "Phase 3: Create compressed filesystem"
    
    "$SCRIPT_DIR/compress.sh" || {
        log_error "Compression phase failed"
        exit 1
    }
    
    log_success "Compression complete"
}

phase_makeiso() {
    log "Phase 4: Generate bootable ISO"
    
    "$SCRIPT_DIR/make-iso.sh" || {
        log_error "ISO generation failed"
        exit 1
    }
    
    log_success "ISO generation complete"
}

################################################################################
# Main Function
################################################################################

main() {
    local start_time
    start_time=$(date +%s)
    
    log "╔════════════════════════════════════════════════════════════════╗"
    log "║           WilderedOS Build System v${WILDEREDOS_VERSION}                  ║"
    log "╚════════════════════════════════════════════════════════════════╝"
    
    # Parse command line arguments
    parse_arguments "$@"
    
    log "Building: WilderedOS $EDITION Edition"
    log "Architecture: $ARCH"
    log "Compression: Level $COMPRESSION_LEVEL"
    log "Work Directory: $WORK_DIR"
    log "Output Directory: $OUTPUT_DIR"
    
    # Verify we're running as root
    check_root
    
    # Check all dependencies are installed
    check_dependencies
    
    # Clean if requested
    if [[ "$CLEAN" == "true" ]]; then
        log "Cleaning previous build..."
        "$SCRIPT_DIR/clean.sh" --all
    fi
    
    # Setup build directories
    setup_directories
    
    # Run build phases
    phase_bootstrap
    phase_customize
    phase_compress
    phase_makeiso
    
    # Calculate build time
    local end_time
    end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))
    
    # Final output
    echo
    log "╔════════════════════════════════════════════════════════════════╗"
    log "║                    BUILD COMPLETE!                             ║"
    log "╚════════════════════════════════════════════════════════════════╝"
    log_success "Edition: WilderedOS $EDITION"
    log_success "Architecture: $ARCH"
    log_success "Build Time: ${minutes}m ${seconds}s"
    log_success "ISO Location: $OUTPUT_DIR/wilderedos-$EDITION-$WILDEREDOS_VERSION-$ARCH.iso"
    echo
    log "Next steps:"
    log "  1. Test ISO: ./build/test-iso.sh $OUTPUT_DIR/wilderedos-$EDITION-$WILDEREDOS_VERSION-$ARCH.iso"
    log "  2. Write to USB: sudo dd if=<iso> of=/dev/sdX bs=4M status=progress"
    log "  3. Boot and enjoy!"
    
    # Cleanup
    cleanup
}

# Trap errors and cleanup
trap cleanup EXIT

# Run main function
main "$@"
