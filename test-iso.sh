#!/bin/bash
################################################################################
# WilderedOS Test-ISO Script
# Test generated ISO in QEMU virtual machine
################################################################################

set -e
set -u

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[Test-ISO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $*"
}

log_error() {
    echo -e "${RED}[✗]${NC} $*" >&2
}

show_usage() {
    cat << EOF
Usage: $0 <iso-file> [OPTIONS]

Test WilderedOS ISO in QEMU virtual machine.

OPTIONS:
    --memory=SIZE      RAM size (default: 2048M)
    --cpus=NUM         Number of CPUs (default: 2)
    --uefi             Boot in UEFI mode instead of BIOS
    --display=TYPE     Display type: sdl, gtk, vnc (default: gtk)
    --help, -h         Show this help message

EXAMPLES:
    # Test with default settings
    $0 wilderedos-base-1.0.0-amd64.iso

    # Test with minimal RAM
    $0 wilderedos-base-1.0.0-amd64.iso --memory=512M

    # Test UEFI boot
    $0 wilderedos-standard-1.0.0-amd64.iso --uefi

    # Test with more resources
    $0 wilderedos-full-1.0.0-amd64.iso --memory=4096M --cpus=4

EOF
}

check_qemu() {
    if ! command -v qemu-system-x86_64 &> /dev/null; then
        log_error "QEMU not found. Please install it:"
        log_error "  sudo apt-get install qemu-system-x86"
        exit 1
    fi
    log_success "QEMU found"
}

test_iso() {
    local iso_file="$1"
    local memory="${2:-2048M}"
    local cpus="${3:-2}"
    local uefi="${4:-false}"
    local display="${5:-gtk}"
    
    log "Testing ISO: $iso_file"
    log "Memory: $memory"
    log "CPUs: $cpus"
    log "UEFI: $uefi"
    log "Display: $display"
    
    # Check if ISO exists
    if [[ ! -f "$iso_file" ]]; then
        log_error "ISO file not found: $iso_file"
        exit 1
    fi
    
    # Build QEMU command
    local qemu_cmd="qemu-system-x86_64"
    local qemu_args=(
        -m "$memory"
        -smp "$cpus"
        -cdrom "$iso_file"
        -boot d
        -enable-kvm
        -display "$display"
        -vga virtio
        -device virtio-net,netdev=net0
        -netdev user,id=net0
    )
    
    # Add UEFI firmware if requested
    if [[ "$uefi" == "true" ]]; then
        if [[ -f /usr/share/ovmf/OVMF.fd ]]; then
            qemu_args+=(-bios /usr/share/ovmf/OVMF.fd)
            log "Using UEFI firmware"
        elif [[ -f /usr/share/qemu/OVMF.fd ]]; then
            qemu_args+=(-bios /usr/share/qemu/OVMF.fd)
            log "Using UEFI firmware"
        else
            log_error "UEFI firmware not found. Install ovmf package:"
            log_error "  sudo apt-get install ovmf"
            exit 1
        fi
    fi
    
    log "Starting QEMU..."
    log "Command: $qemu_cmd ${qemu_args[*]}"
    echo
    log_success "QEMU started. Close the window when done testing."
    
    # Run QEMU
    $qemu_cmd "${qemu_args[@]}"
    
    log_success "QEMU exited"
}

main() {
    # Default values
    local iso_file=""
    local memory="2048M"
    local cpus="2"
    local uefi=false
    local display="gtk"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                show_usage
                exit 0
                ;;
            --memory=*)
                memory="${1#*=}"
                shift
                ;;
            --cpus=*)
                cpus="${1#*=}"
                shift
                ;;
            --uefi)
                uefi=true
                shift
                ;;
            --display=*)
                display="${1#*=}"
                shift
                ;;
            *.iso)
                iso_file="$1"
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Check if ISO file specified
    if [[ -z "$iso_file" ]]; then
        log_error "No ISO file specified"
        show_usage
        exit 1
    fi
    
    # Check dependencies
    check_qemu
    
    # Test ISO
    test_iso "$iso_file" "$memory" "$cpus" "$uefi" "$display"
}

main "$@"
