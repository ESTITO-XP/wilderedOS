#!/bin/bash
################################################################################
# WilderedOS Clean Script
# Cleanup build artifacts and temporary files
################################################################################

set -e
set -u

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config/default.conf"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[Clean]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $*"
}

################################################################################
# Cleanup Functions
################################################################################

show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Clean WilderedOS build artifacts and temporary files.

OPTIONS:
    --all           Remove everything (chroot, image, output, cache, logs)
    --chroot        Remove chroot directory only
    --image         Remove image staging directory
    --output        Remove output ISOs
    --cache         Remove build cache
    --logs          Remove build logs
    --help, -h      Show this help message

EXAMPLES:
    # Clean everything
    sudo $0 --all

    # Clean only chroot and image
    sudo $0 --chroot --image

    # Clean without removing cache (for incremental builds)
    sudo $0 --chroot --image --output --logs

EOF
}

unmount_chroot() {
    log "Unmounting chroot filesystems..."
    
    if [[ -d "$CHROOT_DIR" ]]; then
        # Unmount virtual filesystems
        for mount in proc sys dev/pts dev; do
            if mountpoint -q "$CHROOT_DIR/$mount" 2>/dev/null; then
                umount "$CHROOT_DIR/$mount" || {
                    log_warning "Failed to unmount $mount, trying lazy unmount..."
                    umount -l "$CHROOT_DIR/$mount" || true
                }
            fi
        done
        
        log_success "Chroot unmounted"
    fi
}

clean_chroot() {
    log "Cleaning chroot directory..."
    
    if [[ -d "$CHROOT_DIR" ]]; then
        unmount_chroot
        rm -rf "$CHROOT_DIR"
        log_success "Chroot removed"
    else
        log_warning "Chroot directory not found"
    fi
}

clean_image() {
    log "Cleaning image directory..."
    
    if [[ -d "$IMAGE_DIR" ]]; then
        rm -rf "$IMAGE_DIR"
        log_success "Image directory removed"
    else
        log_warning "Image directory not found"
    fi
}

clean_output() {
    log "Cleaning output ISOs..."
    
    if [[ -d "$OUTPUT_DIR" ]]; then
        local count
        count=$(find "$OUTPUT_DIR" -name "*.iso" | wc -l)
        if [[ $count -gt 0 ]]; then
            rm -f "$OUTPUT_DIR"/*.iso
            rm -f "$OUTPUT_DIR"/*.md5
            rm -f "$OUTPUT_DIR"/*.sha256
            rm -f "$OUTPUT_DIR"/*.info
            log_success "Removed $count ISO(s)"
        else
            log_warning "No ISOs found in output directory"
        fi
    else
        log_warning "Output directory not found"
    fi
}

clean_cache() {
    log "Cleaning build cache..."
    
    if [[ -d "$CACHE_DIR" ]]; then
        local size
        size=$(du -sh "$CACHE_DIR" 2>/dev/null | cut -f1 || echo "0")
        rm -rf "$CACHE_DIR"
        log_success "Cache removed (freed: $size)"
    else
        log_warning "Cache directory not found"
    fi
}

clean_logs() {
    log "Cleaning build logs..."
    
    if [[ -d "$LOG_DIR" ]]; then
        rm -rf "$LOG_DIR"
        log_success "Logs removed"
    else
        log_warning "Log directory not found"
    fi
}

clean_all() {
    log "Cleaning all build artifacts..."
    
    unmount_chroot
    clean_chroot
    clean_image
    clean_output
    clean_cache
    clean_logs
    
    # Remove work directory if empty
    if [[ -d "$WORK_DIR" ]] && [[ -z "$(ls -A "$WORK_DIR")" ]]; then
        rmdir "$WORK_DIR"
        log_success "Work directory removed"
    fi
    
    log_success "All artifacts cleaned"
}

show_disk_usage() {
    log "Current disk usage:"
    
    if [[ -d "$WORK_DIR" ]]; then
        echo "Work Directory: $(du -sh "$WORK_DIR" 2>/dev/null | cut -f1 || echo "N/A")"
    fi
    
    if [[ -d "$CHROOT_DIR" ]]; then
        echo "  Chroot: $(du -sh "$CHROOT_DIR" 2>/dev/null | cut -f1 || echo "N/A")"
    fi
    
    if [[ -d "$IMAGE_DIR" ]]; then
        echo "  Image: $(du -sh "$IMAGE_DIR" 2>/dev/null | cut -f1 || echo "N/A")"
    fi
    
    if [[ -d "$CACHE_DIR" ]]; then
        echo "  Cache: $(du -sh "$CACHE_DIR" 2>/dev/null | cut -f1 || echo "N/A")"
    fi
    
    if [[ -d "$OUTPUT_DIR" ]]; then
        echo "  Output: $(du -sh "$OUTPUT_DIR" 2>/dev/null | cut -f1 || echo "N/A")"
    fi
    
    if [[ -d "$LOG_DIR" ]]; then
        echo "  Logs: $(du -sh "$LOG_DIR" 2>/dev/null | cut -f1 || echo "N/A")"
    fi
}

################################################################################
# Main Function
################################################################################

main() {
    local clean_all_flag=false
    local clean_chroot_flag=false
    local clean_image_flag=false
    local clean_output_flag=false
    local clean_cache_flag=false
    local clean_logs_flag=false
    
    # Parse arguments
    if [[ $# -eq 0 ]]; then
        show_usage
        show_disk_usage
        exit 0
    fi
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --all)
                clean_all_flag=true
                shift
                ;;
            --chroot)
                clean_chroot_flag=true
                shift
                ;;
            --image)
                clean_image_flag=true
                shift
                ;;
            --output)
                clean_output_flag=true
                shift
                ;;
            --cache)
                clean_cache_flag=true
                shift
                ;;
            --logs)
                clean_logs_flag=true
                shift
                ;;
            --help|-h)
                show_usage
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Check root permissions
    if [[ $EUID -ne 0 ]]; then
        log_warning "This script should be run as root for complete cleanup"
        log_warning "Some operations may fail without root permissions"
    fi
    
    # Show current usage
    show_disk_usage
    echo
    
    # Perform cleanup
    if [[ "$clean_all_flag" == "true" ]]; then
        clean_all
    else
        [[ "$clean_chroot_flag" == "true" ]] && clean_chroot
        [[ "$clean_image_flag" == "true" ]] && clean_image
        [[ "$clean_output_flag" == "true" ]] && clean_output
        [[ "$clean_cache_flag" == "true" ]] && clean_cache
        [[ "$clean_logs_flag" == "true" ]] && clean_logs
    fi
    
    echo
    log_success "Cleanup complete!"
}

main "$@"
