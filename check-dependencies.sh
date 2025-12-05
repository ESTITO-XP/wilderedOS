#!/bin/bash
################################################################################
# WilderedOS Check Dependencies Script
# Verifies all build dependencies are installed and working
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
    echo -e "${BLUE}[Check-Deps]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $*"
}

log_error() {
    echo -e "${RED}[✗]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $*"
}

################################################################################
# Check Functions
################################################################################

check_command() {
    local cmd=$1
    local package=${2:-$1}
    local required=${3:-true}
    
    if command -v "$cmd" &> /dev/null; then
        local version
        version=$("$cmd" --version 2>&1 | head -n1 || echo "unknown")
        log_success "$cmd found: $version"
        return 0
    else
        if [[ "$required" == "true" ]]; then
            log_error "$cmd not found (install: $package)"
            return 1
        else
            log_warning "$cmd not found (optional: $package)"
            return 0
        fi
    fi
}

check_file() {
    local file=$1
    local package=$2
    
    if [[ -f "$file" ]]; then
        log_success "File found: $file"
        return 0
    else
        log_error "File not found: $file (install: $package)"
        return 1
    fi
}

check_disk_space() {
    local required_mb=10000  # 10GB
    local available_mb
    
    available_mb=$(df -BM . | tail -1 | awk '{print $4}' | sed 's/M//')
    
    if [[ $available_mb -ge $required_mb ]]; then
        log_success "Disk space: ${available_mb}MB available (${required_mb}MB required)"
        return 0
    else
        log_error "Insufficient disk space: ${available_mb}MB available (${required_mb}MB required)"
        return 1
    fi
}

check_memory() {
    local required_mb=2000  # 2GB
    local available_mb
    
    if [[ -f /proc/meminfo ]]; then
        available_mb=$(grep MemTotal /proc/meminfo | awk '{print int($2/1024)}')
        
        if [[ $available_mb -ge $required_mb ]]; then
            log_success "Memory: ${available_mb}MB available (${required_mb}MB required)"
            return 0
        else
            log_warning "Low memory: ${available_mb}MB available (${required_mb}MB recommended)"
            return 0  # Warning only, not fatal
        fi
    else
        log_warning "Cannot check memory"
        return 0
    fi
}

check_permissions() {
    if [[ $EUID -eq 0 ]]; then
        log_success "Running as root"
        return 0
    else
        log_warning "Not running as root (build will need sudo)"
        return 0
    fi
}

################################################################################
# Main Checks
################################################################################

check_essential_commands() {
    log "Checking essential commands..."
    local failed=0
    
    check_command debootstrap debootstrap || failed=1
    check_command mksquashfs squashfs-tools || failed=1
    check_command xorriso xorriso || failed=1
    check_command grub-mkrescue grub-pc-bin || failed=1
    check_command mkfs.vfat dosfstools || failed=1
    check_command mtools mtools || failed=1
    
    return $failed
}

check_optional_commands() {
    log "Checking optional commands..."
    
    check_command qemu-system-x86_64 qemu-system-x86 false
    check_command parallel parallel false
    check_command pv pv false
    check_command zstd zstd false
    check_command pigz pigz false
    check_command shellcheck shellcheck false
    check_command jq jq false
}

check_grub_files() {
    log "Checking GRUB files..."
    local failed=0
    
    check_file /usr/lib/grub/i386-pc/boot.img grub-pc-bin || failed=1
    check_file /usr/lib/grub/i386-pc/boot_hybrid.img grub-pc-bin || failed=1
    
    return $failed
}

check_system_resources() {
    log "Checking system resources..."
    
    check_permissions
    check_disk_space
    check_memory
}

check_network() {
    log "Checking network connectivity..."
    
    if ping -c 1 -W 2 archive.ubuntu.com &> /dev/null; then
        log_success "Network connectivity OK"
        return 0
    else
        log_warning "Cannot reach archive.ubuntu.com (required for package downloads)"
        return 0
    fi
}

################################################################################
# Summary
################################################################################

show_summary() {
    echo
    echo "=================================="
    echo "  Dependency Check Summary"
    echo "=================================="
    echo
    
    if [[ $1 -eq 0 ]]; then
        log_success "All required dependencies satisfied!"
        echo
        echo "You can now build WilderedOS:"
        echo "  sudo ./build/build.sh base"
        echo
        return 0
    else
        log_error "Some required dependencies are missing"
        echo
        echo "Install missing dependencies:"
        echo "  sudo ./build/install-dependencies.sh"
        echo
        echo "Or install manually:"
        echo "  sudo apt-get install debootstrap squashfs-tools xorriso"
        echo "  sudo apt-get install grub-pc-bin grub-efi-amd64-bin"
        echo "  sudo apt-get install mtools dosfstools"
        echo
        return 1
    fi
}

################################################################################
# Main Function
################################################################################

main() {
    log "WilderedOS Dependency Checker"
    echo
    
    local failed=0
    
    # Run all checks
    check_essential_commands || failed=1
    echo
    
    check_optional_commands
    echo
    
    check_grub_files || failed=1
    echo
    
    check_system_resources
    echo
    
    check_network
    echo
    
    # Show summary
    show_summary $failed
    exit $failed
}

main "$@"
