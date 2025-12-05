#!/bin/bash
################################################################################
# WilderedOS Install Dependencies Script
# Automatically installs all required build dependencies
################################################################################

set -e
set -u

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[Install-Deps]${NC} $*"
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

################################################################################
# Check System
################################################################################

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        DISTRO=$ID
        VERSION=$VERSION_ID
        log "Detected: $NAME $VERSION"
    else
        log_error "Cannot detect distribution"
        exit 1
    fi
}

check_supported() {
    case "$DISTRO" in
        ubuntu|debian|linuxmint|pop)
            log_success "Supported distribution detected"
            return 0
            ;;
        *)
            log_warning "Distribution '$DISTRO' is not officially supported"
            log_warning "Build system may work, but not tested"
            read -p "Continue anyway? (y/N) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
            ;;
    esac
}

################################################################################
# Install Dependencies
################################################################################

update_package_lists() {
    log "Updating package lists..."
    apt-get update -qq
    log_success "Package lists updated"
}

install_essential_packages() {
    log "Installing essential build tools..."
    
    local packages=(
        # Core build tools
        debootstrap
        squashfs-tools
        xorriso
        isolinux
        syslinux-efi
        
        # GRUB bootloader
        grub-pc-bin
        grub-efi-amd64-bin
        grub-efi-ia32-bin
        
        # File system tools
        mtools
        dosfstools
        
        # Utilities
        git
        wget
        curl
        rsync
        
        # Compression
        xz-utils
        gzip
        bzip2
    )
    
    apt-get install -y "${packages[@]}"
    log_success "Essential packages installed"
}

install_optional_packages() {
    log "Installing optional packages for better performance..."
    
    local packages=(
        # Parallel processing
        parallel
        
        # Progress indicators
        pv
        
        # Better compression
        zstd
        pigz
        
        # Checksum tools
        md5deep
        
        # Text processing
        jq
    )
    
    apt-get install -y "${packages[@]}" 2>/dev/null || {
        log_warning "Some optional packages failed to install (non-critical)"
    }
    
    log_success "Optional packages installed"
}

install_qemu() {
    log "Installing QEMU for ISO testing..."
    
    apt-get install -y \
        qemu-system-x86 \
        qemu-utils \
        ovmf 2>/dev/null || {
        log_warning "QEMU installation incomplete (you can install it later)"
        return 0
    }
    
    log_success "QEMU installed"
}

install_shellcheck() {
    log "Installing ShellCheck for script validation..."
    
    apt-get install -y shellcheck 2>/dev/null || {
        log_warning "ShellCheck not available (optional)"
        return 0
    }
    
    log_success "ShellCheck installed"
}

################################################################################
# Verification
################################################################################

verify_installation() {
    log "Verifying installation..."
    
    local required_commands=(
        debootstrap
        mksquashfs
        xorriso
        grub-mkrescue
    )
    
    local missing=0
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            log_error "Required command not found: $cmd"
            missing=1
        fi
    done
    
    if [[ $missing -eq 1 ]]; then
        log_error "Some required dependencies are missing"
        return 1
    fi
    
    log_success "All required dependencies verified"
    return 0
}

show_summary() {
    echo
    echo "=================================="
    echo "  Dependency Installation Complete"
    echo "=================================="
    echo
    log_success "WilderedOS build system is ready!"
    echo
    echo "Next steps:"
    echo "  1. Verify dependencies: ./build/check-dependencies.sh"
    echo "  2. Build Base Edition: sudo ./build/build.sh base"
    echo "  3. Test ISO: ./build/test-iso.sh build/output/wilderedos-*.iso"
    echo
}

################################################################################
# Main Function
################################################################################

main() {
    log "WilderedOS Dependency Installer"
    echo
    
    # Check prerequisites
    check_root
    detect_distro
    check_supported
    
    echo
    log "Installing dependencies..."
    echo
    
    # Install packages
    update_package_lists
    install_essential_packages
    install_optional_packages
    install_qemu
    install_shellcheck
    
    echo
    
    # Verify
    if verify_installation; then
        show_summary
        exit 0
    else
        log_error "Installation verification failed"
        log_error "Please check errors above and try again"
        exit 1
    fi
}

main "$@"
