#!/bin/bash
################################################################################
# WilderedOS Font Installation Script
# Installs Zalando Sans fonts into the build chroot
################################################################################

set -e
set -u

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/config/default.conf"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[Fonts]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $*"
}

################################################################################
# Font Installation
################################################################################

FONT_DIR="$CHROOT_DIR/usr/share/fonts/truetype/zalando"
TEMP_FONT_DIR="/tmp/wilderedos-fonts"

download_fonts() {
    log "Downloading Zalando Sans fonts..."
    
    mkdir -p "$TEMP_FONT_DIR"
    cd "$TEMP_FONT_DIR"
    
    # Zalando Sans Expanded (SemiBold 600 for branding)
    log "Downloading Zalando Sans Expanded SemiBold..."
    wget -q "https://github.com/google/fonts/raw/main/ofl/zalandosansexpanded/ZalandoSansExpanded-SemiBold.ttf"
    
    # Zalando Sans (Medium 500 for system)
    log "Downloading Zalando Sans Medium..."
    wget -q "https://github.com/google/fonts/raw/main/ofl/zalandosans/ZalandoSans-Medium.ttf"
    
    # Download additional weights for flexibility
    log "Downloading additional font weights..."
    
    # Zalando Sans Regular (fallback)
    wget -q "https://github.com/google/fonts/raw/main/ofl/zalandosans/ZalandoSans-Regular.ttf" || true
    
    # Zalando Sans Bold (for emphasis)
    wget -q "https://github.com/google/fonts/raw/main/ofl/zalandosans/ZalandoSans-Bold.ttf" || true
    
    # Zalando Sans Expanded Bold (for extra emphasis)
    wget -q "https://github.com/google/fonts/raw/main/ofl/zalandosansexpanded/ZalandoSansExpanded-Bold.ttf" || true
    
    log_success "Fonts downloaded"
}

install_fonts() {
    log "Installing fonts to chroot..."
    
    # Create font directory
    mkdir -p "$FONT_DIR"
    
    # Copy fonts
    cp "$TEMP_FONT_DIR"/*.ttf "$FONT_DIR/" 2>/dev/null || true
    
    # Set permissions
    chmod 644 "$FONT_DIR"/*.ttf
    
    log_success "Fonts installed to $FONT_DIR"
}

configure_fontconfig() {
    log "Configuring fontconfig..."
    
    # Create fontconfig directory
    mkdir -p "$CHROOT_DIR/etc/fonts/conf.d"
    
    # Create Zalando Sans configuration
    cat > "$CHROOT_DIR/etc/fonts/conf.d/69-zalando-sans.conf" << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- Zalando Sans as default sans-serif -->
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Zalando Sans</family>
      <family>Liberation Sans</family>
      <family>DejaVu Sans</family>
    </prefer>
  </alias>

  <!-- Zalando Sans Expanded for display -->
  <alias>
    <family>display</family>
    <prefer>
      <family>Zalando Sans Expanded</family>
    </prefer>
  </alias>

  <!-- Good rendering settings -->
  <match target="font">
    <test name="family" compare="eq">
      <string>Zalando Sans</string>
    </test>
    <edit name="antialias" mode="assign">
      <bool>true</bool>
    </edit>
    <edit name="hinting" mode="assign">
      <bool>true</bool>
    </edit>
    <edit name="hintstyle" mode="assign">
      <const>hintslight</const>
    </edit>
    <edit name="rgba" mode="assign">
      <const>rgb</const>
    </edit>
  </match>

  <match target="font">
    <test name="family" compare="eq">
      <string>Zalando Sans Expanded</string>
    </test>
    <edit name="antialias" mode="assign">
      <bool>true</bool>
    </edit>
    <edit name="hinting" mode="assign">
      <bool>true</bool>
    </edit>
    <edit name="hintstyle" mode="assign">
      <const>hintmedium</const>
    </edit>
    <edit name="rgba" mode="assign">
      <const>rgb</const>
    </edit>
  </match>
</fontconfig>
EOF
    
    log_success "Fontconfig configured"
}

update_font_cache() {
    log "Updating font cache..."
    
    # Update font cache in chroot
    chroot "$CHROOT_DIR" fc-cache -f -v > /dev/null 2>&1 || true
    
    log_success "Font cache updated"
}

create_font_library() {
    log "Creating font library..."
    
    mkdir -p "$CHROOT_DIR/opt/wilderedos/lib"
    
    cat > "$CHROOT_DIR/opt/wilderedos/lib/fonts.sh" << 'EOF'
#!/bin/bash
# WilderedOS Font Configuration Library

# Font paths
ZALANDO_SANS_EXPANDED="/usr/share/fonts/truetype/zalando/ZalandoSansExpanded-SemiBold.ttf"
ZALANDO_SANS="/usr/share/fonts/truetype/zalando/ZalandoSans-Medium.ttf"

# Check if fonts are installed
check_fonts() {
    if fc-list | grep -q "Zalando Sans"; then
        return 0
    else
        return 1
    fi
}

# Get display font for headers
get_display_font() {
    if check_fonts; then
        echo "Zalando Sans Expanded"
    else
        echo "Liberation Sans"
    fi
}

# Get system font for body text
get_system_font() {
    if check_fonts; then
        echo "Zalando Sans"
    else
        echo "Liberation Mono"
    fi
}

# Set terminal font
set_terminal_font() {
    local font="${1:-Zalando Sans}"
    local size="${2:-12}"
    
    # Configure for current terminal
    if [ -n "${FBTERM:-}" ]; then
        export FBTERM_FONT="$font"
        export FBTERM_FONT_SIZE="$size"
    fi
}

# Export functions
export -f check_fonts
export -f get_display_font
export -f get_system_font
export -f set_terminal_font
EOF
    
    chmod +x "$CHROOT_DIR/opt/wilderedos/lib/fonts.sh"
    
    log_success "Font library created"
}

verify_installation() {
    log "Verifying font installation..."
    
    # List installed fonts
    local fonts_found
    fonts_found=$(chroot "$CHROOT_DIR" fc-list | grep -c "Zalando" || echo "0")
    
    if [ "$fonts_found" -gt 0 ]; then
        log_success "Found $fonts_found Zalando Sans font(s)"
        
        # Show installed fonts
        log "Installed fonts:"
        chroot "$CHROOT_DIR" fc-list | grep "Zalando" | while read -r line; do
            echo "  - $line"
        done
    else
        log "Warning: No Zalando Sans fonts found"
        log "Fallback fonts will be used"
    fi
}

cleanup() {
    log "Cleaning up temporary files..."
    rm -rf "$TEMP_FONT_DIR"
    log_success "Cleanup complete"
}

################################################################################
# Main Function
################################################################################

main() {
    log "Starting font installation..."
    
    download_fonts
    install_fonts
    configure_fontconfig
    update_font_cache
    create_font_library
    verify_installation
    cleanup
    
    log_success "Font installation complete!"
}

main "$@"
