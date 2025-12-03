#!/bin/bash
################################################################################
# WilderedOS Customize Script
# Installs WilderedOS-specific packages and configurations
################################################################################

set -e
set -u

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config/default.conf"
[[ -f "$SCRIPT_DIR/config/local.conf" ]] && source "$SCRIPT_DIR/config/local.conf"

# Load edition config if available
if [[ -n "${EDITION:-}" ]] && [[ -f "$SCRIPT_DIR/config/$EDITION.conf" ]]; then
    source "$SCRIPT_DIR/config/$EDITION.conf"
fi

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[Customize]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $*"
}

################################################################################
# Customization Functions
################################################################################

install_terminal_packages() {
    log "Installing terminal and TUI packages..."
    
    # Read package list for edition
    local package_list="$SCRIPT_DIR/packages/${EDITION}.list"
    if [[ ! -f "$package_list" ]]; then
        log_warning "Package list not found: $package_list"
        package_list="$SCRIPT_DIR/packages/base.list"
    fi
    
    # Install packages from list
    if [[ -f "$package_list" ]]; then
        local packages
        packages=$(grep -v '^#' "$package_list" | grep -v '^$' | tr '\n' ' ')
        
        chroot "$CHROOT_DIR" apt-get update
        chroot "$CHROOT_DIR" apt-get install -y --no-install-recommends $packages
    fi
    
    # Install extra packages if specified
    if [[ -n "${EXTRA_PACKAGES:-}" ]]; then
        log "Installing extra packages: $EXTRA_PACKAGES"
        chroot "$CHROOT_DIR" apt-get install -y --no-install-recommends ${EXTRA_PACKAGES//,/ }
    fi
    
    log_success "Terminal packages installed"
}

install_wilderedos_components() {
    log "Installing WilderedOS custom components..."
    
    # Create WilderedOS directories
    mkdir -p "$CHROOT_DIR/opt/wilderedos"/{bin,lib,share,etc,var}
    mkdir -p "$CHROOT_DIR/opt/wilderedos/share"/{themes,ascii-art,templates,presets}
    
    # Copy WilderedOS scripts and tools
    if [[ -d "$PROJECT_ROOT/src" ]]; then
        cp -r "$PROJECT_ROOT/src/"* "$CHROOT_DIR/opt/wilderedos/" || true
    fi
    
    # Make scripts executable
    chmod +x "$CHROOT_DIR/opt/wilderedos/bin/"* 2>/dev/null || true
    
    log_success "WilderedOS components installed"
}

install_themes() {
    log "Installing WilderedOS themes..."
    
    # Copy theme files
    if [[ -d "$SCRIPT_DIR/themes" ]]; then
        cp "$SCRIPT_DIR/themes/"*.theme "$CHROOT_DIR/opt/wilderedos/share/themes/" 2>/dev/null || true
    fi
    
    # Set default theme
    local default_theme="${DEFAULT_THEME:-liquid-glass}"
    if [[ -f "$CHROOT_DIR/opt/wilderedos/share/themes/$default_theme.theme" ]]; then
        ln -sf "/opt/wilderedos/share/themes/$default_theme.theme" \
               "$CHROOT_DIR/opt/wilderedos/etc/default-theme.conf"
    fi
    
    log_success "Themes installed"
}

configure_shell() {
    log "Configuring shell environment..."
    
    # Install shell configuration
    cat > "$CHROOT_DIR/etc/skel/.bashrc" << 'EOF'
# WilderedOS Bash Configuration

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# Check window size after each command
shopt -s checkwinsize

# Colored prompt
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi

# Load WilderedOS theme if available
if [ -f /opt/wilderedos/lib/theme.sh ]; then
    source /opt/wilderedos/lib/theme.sh
fi

# Aliases
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

# Add WilderedOS bin to PATH
export PATH="/opt/wilderedos/bin:$PATH"
EOF

    # Copy to existing user
    cp "$CHROOT_DIR/etc/skel/.bashrc" "$CHROOT_DIR/home/$LIVE_USER/.bashrc"
    chroot "$CHROOT_DIR" chown "$LIVE_USER:$LIVE_USER" "/home/$LIVE_USER/.bashrc"
    
    log_success "Shell configured"
}

configure_tmux() {
    log "Configuring tmux..."
    
    cat > "$CHROOT_DIR/etc/skel/.tmux.conf" << 'EOF'
# WilderedOS tmux Configuration

# Set prefix to Ctrl-a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Enable mouse support
set -g mouse on

# Start windows and panes at 1
set -g base-index 1
setw -g pane-base-index 1

# Status bar
set -g status-position bottom
set -g status-bg colour234
set -g status-fg colour137
set -g status-left ''
set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '

# Window status
setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '
setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

# Pane borders
set -g pane-border-style fg=colour238
set -g pane-active-border-style fg=colour51

# Message text
set -g message-style bg=colour235,fg=colour166

# Load WilderedOS theme colors if available
if-shell "test -f /opt/wilderedos/lib/tmux-theme.conf" \
    "source-file /opt/wilderedos/lib/tmux-theme.conf"
EOF

    # Copy to user
    cp "$CHROOT_DIR/etc/skel/.tmux.conf" "$CHROOT_DIR/home/$LIVE_USER/.tmux.conf"
    chroot "$CHROOT_DIR" chown "$LIVE_USER:$LIVE_USER" "/home/$LIVE_USER/.tmux.conf"
    
    log_success "Tmux configured"
}

setup_ascii_art() {
    log "Setting up ASCII art..."
    
    # Copy ASCII art
    if [[ -f "$PROJECT_ROOT/ASCII.md" ]]; then
        # Extract ASCII art from markdown
        sed -n '/^```/,/^```/p' "$PROJECT_ROOT/ASCII.md" | sed '1d;$d' > \
            "$CHROOT_DIR/opt/wilderedos/share/ascii-art/logo.txt" 2>/dev/null || true
    fi
    
    # Create MOTD
    cat > "$CHROOT_DIR/etc/motd" << 'EOF'
Welcome to WilderedOS!

A terminal-based Linux distribution designed for performance and simplicity.

Quick Start:
  - File Manager: ranger or wildfiles
  - Settings: wildsettings
  - Theme: wilderedos-theme list
  - Help: wilderedos-help

For documentation, visit: https://github.com/ESTITO-XP/WilderedOS
EOF
    
    log_success "ASCII art configured"
}

configure_sidebar() {
    log "Configuring sidebar companion..."
    
    # Check if sidebar is enabled for this edition
    if [[ "${ENABLE_SIDEBAR:-false}" == "true" ]]; then
        # Create sidebar configuration
        mkdir -p "$CHROOT_DIR/etc/wilderedos"
        cat > "$CHROOT_DIR/etc/wilderedos/sidebar.conf" << 'EOF'
# Sidebar Companion Configuration

[general]
enabled = true
position = right
width = 25
auto_hide = false
update_interval = 2

[widgets]
system_monitor = true
clock = true
calendar = false
quick_launch = true
recent_files = true
notifications = true

[appearance]
use_theme = true
border = true
transparency = 10
EOF
        
        log_success "Sidebar configured"
    else
        log_warning "Sidebar disabled for this edition"
    fi
}

configure_smart_storage() {
    log "Configuring Smart Storage..."
    
    if [[ "${ENABLE_SMART_STORAGE:-false}" == "true" ]]; then
        mkdir -p "$CHROOT_DIR/etc/wilderedos"
        cat > "$CHROOT_DIR/etc/wilderedos/storage.conf" << 'EOF'
# Smart Storage Configuration

[general]
enabled = true
auto_categorize = true
watch_directories = /home

[categories]
development = true
productivity = true
internet = true
multimedia = true
games = true
system = true
utilities = true

[archiving]
enabled = true
threshold_days = 30
compression = zstd
notify = true
EOF
        
        log_success "Smart Storage configured"
    else
        log_warning "Smart Storage disabled for this edition"
    fi
}

install_bootloader() {
    log "Installing bootloader..."
    
    # Install GRUB for both BIOS and UEFI
    chroot "$CHROOT_DIR" apt-get install -y \
        grub-pc-bin \
        grub-efi-amd64-bin \
        grub-efi-ia32-bin
    
    log_success "Bootloader installed"
}

configure_network() {
    log "Configuring network..."
    
    # Configure NetworkManager
    chroot "$CHROOT_DIR" systemctl enable NetworkManager
    
    # Create basic network configuration
    cat > "$CHROOT_DIR/etc/NetworkManager/NetworkManager.conf" << 'EOF'
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=false

[device]
wifi.scan-rand-mac-address=no
EOF
    
    log_success "Network configured"
}

configure_services() {
    log "Configuring system services..."
    
    # Enable essential services
    chroot "$CHROOT_DIR" systemctl enable systemd-networkd || true
    chroot "$CHROOT_DIR" systemctl enable systemd-resolved || true
    
    # Disable unnecessary services
    chroot "$CHROOT_DIR" systemctl disable apt-daily.timer || true
    chroot "$CHROOT_DIR" systemctl disable apt-daily-upgrade.timer || true
    
    log_success "Services configured"
}

apply_overlay() {
    log "Applying configuration overlay..."
    
    # Copy overlay files if they exist
    if [[ -d "$SCRIPT_DIR/overlay" ]]; then
        cp -r "$SCRIPT_DIR/overlay/"* "$CHROOT_DIR/" 2>/dev/null || true
        log_success "Overlay applied"
    else
        log_warning "No overlay directory found"
    fi
}

cleanup_customize() {
    log "Cleaning up customization..."
    
    # Clean package cache
    chroot "$CHROOT_DIR" apt-get autoremove -y
    chroot "$CHROOT_DIR" apt-get clean
    
    # Remove unnecessary files
    rm -rf "$CHROOT_DIR/var/lib/apt/lists/"*
    rm -rf "$CHROOT_DIR/tmp/"*
    rm -rf "$CHROOT_DIR/var/tmp/"*
    
    # Clear logs
    find "$CHROOT_DIR/var/log" -type f -exec truncate -s 0 {} \; 2>/dev/null || true
    
    log_success "Cleanup complete"
}

################################################################################
# Main Customization Process
################################################################################

main() {
    log "Starting customization for $EDITION edition..."
    
    # Run customization steps
    install_terminal_packages
    install_wilderedos_components
    install_themes
    configure_shell
    configure_tmux
    setup_ascii_art
    configure_sidebar
    configure_smart_storage
    install_bootloader
    configure_network
    configure_services
    apply_overlay
    cleanup_customize
    
    log_success "Customization phase complete!"
}

main "$@"
