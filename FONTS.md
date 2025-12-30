# WilderedOS Typography System

<div align="center">

**_Modern, readable fonts optimized for terminal interfaces_**

</div>

---

## Table of Contents
- **[Typography Overview](#typography-overview)**
- **[Font Hierarchy](#font-hierarchy)**
- **[Font Specifications](#font-specifications)**
- **[Installation](#installation)**
- **[Configuration](#configuration)**
- **[Usage Guidelines](#usage-guidelines)**
- **[Fallback Fonts](#fallback-fonts)**

---

## Typography Overview

WilderedOS uses a carefully curated typography system based on **Zalando Sans** font family, chosen for its excellent readability in terminal environments and modern aesthetic that aligns with the "liquid glass" design language.

**Design Principle:** Use Zalando Sans Expanded for branding/headers, Zalando Sans for body text and UI elements.

---

## Font Hierarchy

### Primary Fonts

**1. Zalando Sans Expanded (Display/Branding)**
- **Use Case:** Startup screen, boot splash, large headers, branding
- **Weight:** SemiBold 600
- **Characteristics:** Wide, eye-catching, modern
- **[Source](https://fonts.google.com/specimen/Zalando+Sans+Expanded?preview.text=Text&query=Zalando)**

**2. Zalando Sans (System/UI)**
- **Use Case:** Main system font, terminal text, UI elements, file names, menus
- **Weight:** Medium 500
- **Characteristics:** Readable, clean, professional
- **[Source](https://fonts.google.com/specimen/Zalando+Sans?preview.text=Text&query=Zalando)**

---

## Font Specifications

### Zalando Sans Expanded

```
Family: Zalando Sans Expanded
Weights Available: 200, 300, 400, 500, 600, 700, 800, 900
Default Weight: 600 (SemiBold)
Style: Normal
Format: TTF, OTF, WOFF2
License: SIL Open Font License
```

**Usage:**
- Boot splash ASCII art
- GRUB boot menu title
- Welcome screen header
- Application launcher titles
- Section headers in documentation
- Error/warning dialog titles

**Example:**
```
╔════════════════════════════════════════╗
║                                        ║
║         W I L D E R E D   O S         ║
║                                        ║
╚════════════════════════════════════════╝
```

### Zalando Sans

```
Family: Zalando Sans
Weights Available: 200, 300, 400, 500, 600, 700, 800, 900
Default Weight: 500 (Medium)
Style: Normal
Format: TTF, OTF, WOFF2
License: SIL Open Font License
```

**Usage:**
- Terminal prompt
- File manager content
- System logs
- Configuration menus
- Body text in TUI applications
- Status bar text
- Sidebar content
- Button labels
- Input fields

**Example:**
```
user@wilderedos:~/Documents$ ls -la
drwxr-xr-x  2 user user 4096 Dec 30 10:30 Projects
-rw-r--r--  1 user user 2048 Dec 30 09:15 notes.txt
```

---

## Installation

### Automatic Installation (during build)

Fonts are automatically installed during the WilderedOS build process.

**Package list includes:**
```bash
# In packages/*.list
fonts-zalando-sans
fonts-zalando-sans-expanded
```

### Manual Installation

```bash
# Download fonts
mkdir -p ~/.local/share/fonts/zalando
cd ~/.local/share/fonts/zalando

# Download Zalando Sans Expanded
wget https://github.com/google/fonts/raw/main/ofl/zalandosansexpanded/ZalandoSansExpanded-SemiBold.ttf

# Download Zalando Sans
wget https://github.com/google/fonts/raw/main/ofl/zalandosans/ZalandoSans-Medium.ttf

# Refresh font cache
fc-cache -f -v
```

### Verify Installation

```bash
# Check if fonts are available
fc-list | grep Zalando

# Expected output:
# /usr/share/fonts/.../ZalandoSansExpanded-SemiBold.ttf: Zalando Sans Expanded:style=SemiBold
# /usr/share/fonts/.../ZalandoSans-Medium.ttf: Zalando Sans:style=Medium
```

---

## Configuration

### Terminal Configuration

**For fbterm:**
```bash
# /etc/fbterm/fbterm.conf
font-names=Zalando Sans
font-size=14
```

**For tmux:**
```bash
# ~/.tmux.conf
set -g default-terminal "screen-256color"
# Font is inherited from terminal emulator
```

**For console (Linux framebuffer):**
```bash
# /etc/default/console-setup
FONTFACE="ZalandoSans"
FONTSIZE="8x16"
```

### Application Configuration

**File Manager (ranger):**
```python
# ~/.config/ranger/rc.conf
set preview_text_font Zalando Sans
```

**Text Editor (vim/neovim):**
```vim
" ~/.vimrc or ~/.config/nvim/init.vim
set guifont=Zalando\ Sans:h12
```

### Boot Screen Configuration

**GRUB Configuration:**
```bash
# /etc/default/grub
GRUB_FONT="/usr/share/grub/zalando-sans-expanded.pf2"
```

**Generate GRUB font:**
```bash
sudo grub-mkfont \
  --output=/usr/share/grub/zalando-sans-expanded.pf2 \
  --size=24 \
  /usr/share/fonts/truetype/zalando/ZalandoSansExpanded-SemiBold.ttf
```

---

## Usage Guidelines

### Font Size Recommendations

| Context | Font | Size | Weight |
|---------|------|------|--------|
| Boot splash | Zalando Sans Expanded | 24-32pt | 600 |
| Terminal | Zalando Sans | 12-14pt | 500 |
| Sidebar | Zalando Sans | 10-12pt | 500 |
| Headers | Zalando Sans Expanded | 16-20pt | 600 |
| Body text | Zalando Sans | 12pt | 500 |
| Small UI | Zalando Sans | 10pt | 500 |

### Line Height

- **Terminal:** 1.2-1.3x font size
- **UI Elements:** 1.4-1.5x font size
- **Documentation:** 1.5-1.6x font size

### Letter Spacing

- **Zalando Sans Expanded:** 0-0.05em (tight, for impact)
- **Zalando Sans:** 0em (normal, optimized)

---

## Fallback Fonts

In case Zalando Sans fonts are unavailable, WilderedOS uses this fallback chain:

```
Primary: Zalando Sans Expanded / Zalando Sans
   ↓
Fallback 1: Liberation Sans / Liberation Mono
   ↓
Fallback 2: DejaVu Sans / DejaVu Sans Mono
   ↓
Fallback 3: System Default Monospace
```

**Configuration:**
```css
/* CSS-style font stack */
font-family: "Zalando Sans", "Liberation Sans", "DejaVu Sans", sans-serif;

/* Terminal monospace stack */
font-family: "Zalando Sans", "Liberation Mono", "DejaVu Sans Mono", monospace;
```

**Install fallback fonts:**
```bash
sudo apt-get install \
  fonts-liberation \
  fonts-dejavu-core \
  fonts-dejavu-extra
```

---

## Font Configuration Files

### System-wide Font Config

**Create `/etc/fonts/conf.d/69-zalando-sans.conf`:**

```xml
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

  <!-- Ensure good rendering -->
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
</fontconfig>
```

### WilderedOS Font Library

**Create `/opt/wilderedos/lib/fonts.sh`:**

```bash
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
    if [ -n "$FBTERM" ]; then
        # fbterm
        export FBTERM_FONT="$font"
        export FBTERM_FONT_SIZE="$size"
    fi
}

# Export functions
export -f check_fonts
export -f get_display_font
export -f get_system_font
export -f set_terminal_font
```

---

## Integration with Theme System

Fonts integrate with the WilderedOS theming system:

**In theme files:**
```ini
[fonts]
display_font = "Zalando Sans Expanded"
display_weight = 600
display_size = 24

system_font = "Zalando Sans"
system_weight = 500
system_size = 12

monospace_font = "Zalando Sans"
monospace_weight = 500
monospace_size = 12

# Fallbacks
fallback_display = "Liberation Sans"
fallback_system = "DejaVu Sans"
fallback_monospace = "Liberation Mono"
```

---

## Accessibility Considerations

### Font Sizes for Readability

**Minimum sizes:**
- Terminal: 10pt (for high DPI), 12pt (standard)
- UI Elements: 10pt minimum
- Headers: 16pt minimum

### High Contrast Mode

For users with visual impairments:
- Use Medium 500 weight minimum (never lighter)
- Increase default sizes by 20%
- Ensure 4.5:1 contrast ratio minimum

### Scaling Support

```bash
# User can scale fonts system-wide
export WILDEREDOS_FONT_SCALE=1.2  # 120% scaling
```

---

## Font Rendering Optimization

### Antialiasing

```bash
# Enable subpixel rendering for LCD screens
export FREETYPE_PROPERTIES="truetype:interpreter-version=38"
```

### Hinting

- **Zalando Sans:** Use slight hinting for best results
- **Zalando Sans Expanded:** Use medium hinting for clarity

---

## Testing Fonts

### Visual Test

```bash
# Display font samples
echo "==================================="
echo "Zalando Sans Expanded (SemiBold 600)"
echo "WILDEREDOS - STARTUP SCREEN"
echo "==================================="
echo ""
echo "Zalando Sans (Medium 500)"
echo "System Font - Icon Name - File Manager"
echo "user@wilderedos:~/Documents$"
```

### Font Rendering Test

```bash
# Test all available weights
for weight in 200 300 400 500 600 700 800 900; do
    echo "Weight $weight: The quick brown fox jumps over the lazy dog"
done
```

---

## License Information

**Zalando Sans & Zalando Sans Expanded**
- License: SIL Open Font License 1.1
- Copyright: Zalando SE
- Free for commercial and personal use
- Modification and redistribution permitted

Full license: https://scripts.sil.org/OFL

---

## Resources

- **[Google Fonts](https://fonts.google.com)**
- **[Zalando Sans](https://fonts.google.com/specimen/Zalando+Sans)**
- **[Zalando Sans Expanded](https://fonts.google.com/specimen/Zalando+Sans+Expanded)**
- **[GitHub Repository](https://github.com/google/fonts/tree/main/ofl/zalandosans)**

---

## Quick Reference

```bash
# Display font (branding)
Font: Zalando Sans Expanded
Weight: 600 (SemiBold)
Use: Boot splash, headers, titles

# System font (UI)
Font: Zalando Sans
Weight: 500 (Medium)
Use: Terminal, file manager, menus, body text

# Installation
sudo apt-get install fonts-zalando-sans fonts-zalando-sans-expanded

# Verification
fc-list | grep Zalando

# Configuration
/etc/fonts/conf.d/69-zalando-sans.conf
/opt/wilderedos/lib/fonts.sh
```

---

**Typography makes the difference between good and great design. WilderedOS uses professional, readable fonts that enhance the user experience.** ✨
