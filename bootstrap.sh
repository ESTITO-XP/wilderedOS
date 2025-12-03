#!/bin/bash
################################################################################
# WilderedOS Bootstrap Script
# Creates base Ubuntu system using debootstrap
################################################################################

set -e
set -u

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config/default.conf"
[[ -f "$SCRIPT_DIR/config/local.conf" ]] && source "$SCRIPT_DIR/config/local.conf"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[Bootstrap]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $*"
}

################################################################################
# Bootstrap Functions
################################################################################

run_debootstrap() {
    log "Running debootstrap for $UBUNTU_RELEASE ($ARCH)..."
    
    # Create chroot directory
    mkdir -p "$CHROOT_DIR"
    
    # Run debootstrap
    debootstrap \
        --arch="$ARCH" \
        --variant=minbase \
        --components=main,universe,restricted,multiverse \
        "$UBUNTU_RELEASE" \
        "$CHROOT_DIR" \
        "$UBUNTU_MIRROR" || {
            log "Error: debootstrap failed"
            exit 1
        }
    
    log_success "Base system created"
}

configure_apt() {
    log "Configuring APT sources..."
    
    # Create sources.list
    cat > "$CHROOT_DIR/etc/apt/sources.list" << EOF
# Ubuntu Main Repositories
deb $UBUNTU_MIRROR $UBUNTU_RELEASE main restricted universe multiverse
deb $UBUNTU_MIRROR $UBUNTU_RELEASE-updates main restricted universe multiverse
deb $UBUNTU_MIRROR $UBUNTU_RELEASE-security main restricted universe multiverse
deb $UBUNTU_MIRROR $UBUNTU_RELEASE-backports main restricted universe multiverse

# Source repositories (optional)
# deb-src $UBUNTU_MIRROR $UBUNTU_RELEASE main restricted universe multiverse
EOF
    
    log_success "APT sources configured"
}

mount_system() {
    log "Mounting system filesystems..."
    
    # Mount proc, sys, dev
    mount --bind /proc "$CHROOT_DIR/proc"
    mount --bind /sys "$CHROOT_DIR/sys"
    mount --bind /dev "$CHROOT_DIR/dev"
    mount --bind /dev/pts "$CHROOT_DIR/dev/pts"
    
    log_success "Filesystems mounted"
}

install_base_packages() {
    log "Installing base packages..."
    
    # Update package lists
    chroot "$CHROOT_DIR" apt-get update
    
    # Install essential packages
    chroot "$CHROOT_DIR" apt-get install -y \
        linux-image-generic \
        linux-headers-generic \
        systemd \
        systemd-sysv \
        udev \
        dbus \
        network-manager \
        iproute2 \
        iputils-ping \
        wget \
        curl \
        ca-certificates \
        locales \
        sudo
    
    log_success "Base packages installed"
}

configure_locale() {
    log "Configuring locale..."
    
    # Generate locale
    echo "en_US.UTF-8 UTF-8" > "$CHROOT_DIR/etc/locale.gen"
    chroot "$CHROOT_DIR" locale-gen
    
    # Set default locale
    echo 'LANG=en_US.UTF-8' > "$CHROOT_DIR/etc/default/locale"
    
    log_success "Locale configured"
}

configure_hostname() {
    log "Configuring hostname..."
    
    echo "wilderedos" > "$CHROOT_DIR/etc/hostname"
    
    cat > "$CHROOT_DIR/etc/hosts" << EOF
127.0.0.1   localhost
127.0.1.1   wilderedos

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF
    
    log_success "Hostname configured"
}

configure_user() {
    log "Creating default user..."
    
    # Create wilderedos user
    chroot "$CHROOT_DIR" useradd -m -s /bin/bash -G sudo wilderedos
    
    # Set default password (user should change on first login)
    echo "wilderedos:wilderedos" | chroot "$CHROOT_DIR" chpasswd
    
    # Configure sudo without password for installation
    echo "wilderedos ALL=(ALL) NOPASSWD:ALL" > "$CHROOT_DIR/etc/sudoers.d/wilderedos"
    chmod 0440 "$CHROOT_DIR/etc/sudoers.d/wilderedos"
    
    log_success "Default user created"
}

cleanup_bootstrap() {
    log "Cleaning up bootstrap..."
    
    # Clean apt cache
    chroot "$CHROOT_DIR" apt-get clean
    
    # Remove temporary files
    rm -rf "$CHROOT_DIR/tmp/*"
    rm -rf "$CHROOT_DIR/var/tmp/*"
    
    log_success "Bootstrap cleanup complete"
}

################################################################################
# Main Bootstrap Process
################################################################################

main() {
    log "Starting bootstrap process..."
    log "Target: $UBUNTU_RELEASE ($ARCH)"
    log "Mirror: $UBUNTU_MIRROR"
    
    # Run bootstrap steps
    run_debootstrap
    configure_apt
    mount_system
    install_base_packages
    configure_locale
    configure_hostname
    configure_user
    cleanup_bootstrap
    
    log_success "Bootstrap phase complete!"
}

main "$@"
