# WilderedOS Theming System

<div align="center">

**_Dynamic Color Management for Terminal Interfaces_**

</div>

---

## Table of Contents
- [Overview](#overview)
- [Theme Architecture](#theme-architecture)
- [Theme File Format](#theme-file-format)
- [Color Palette Structure](#color-palette-structure)
- [Theme Application](#theme-application)
- [Creating Custom Themes](#creating-custom-themes)
- [Theme Repository](#theme-repository)
- [Live Theme Switching](#live-theme-switching)
- [Default Themes](#default-themes)

---

## Overview

WilderedOS uses a centralized theming system that allows colors to be changed easily and applied consistently across all components. Rather than hardcoding colors in the architecture, themes are defined in external configuration files that can be swapped, shared, and modified without touching system code.

**Key Benefits:**
- Change entire system color scheme with one command
- Share themes with the community
- Support light mode, dark mode, and custom aesthetics
- Easy A/B testing of different color palettes
- No code changes required for color updates
- Automatic consistency across all TUI applications

---

## Theme Architecture

### Centralized Theme Management

```
/opt/wilderedos/share/themes/
├── default-dark.theme
├── default-light.theme
├── liquid-glass.theme
├── nord.theme
├── dracula.theme
├── gruvbox.theme
└── custom/
    └── user-themes/

~/.config/wilderedos/
├── current-theme.conf     # Symlink to active theme
└── theme-override.conf    # User color overrides
```

### Theme Loading Priority

1. **System Default** - `/opt/wilderedos/share/themes/default-dark.theme`
2. **User Selection** - `~/.config/wilderedos/current-theme.conf`
3. **User Overrides** - `~/.config/wilderedos/theme-override.conf`
4. **Environment Variables** - Runtime color overrides

### Theme Components

Every WilderedOS theme defines colors for:
- Terminal base colors (16 ANSI colors)
- Extended colors (256-color palette mappings)
- True color values (24-bit RGB)
- UI semantic colors (success, warning, error, info)
- Component-specific colors (sidebar, prompt, file manager)
- Transparency and blur settings

---

## Theme File Format

Themes are stored in INI-style configuration files with clear sections and comments.

### Basic Theme Structure

```ini
[meta]
name = "Liquid Glass"
author = "ESTITO XP"
version = "1.0.0"
description = "The signature WilderedOS theme with semi-transparent blue tones"
base = "dark"  # or "light"

[terminal]
# Background and foreground
background = "#1a1a2e"
foreground = "#e0e0e0"
transparency = 15  # Percentage (0-100)
blur = true

# Cursor
cursor = "#5dade2"
cursor_text = "#1a1a2e"

[ansi]
# Standard 16 ANSI colors
black = "#16213e"
red = "#e74c3c"
green = "#52be80"
yellow = "#f39c12"
blue = "#5dade2"
magenta = "#bb8fce"
cyan = "#48c9b0"
white = "#e0e0e0"

# Bright variants
bright_black = "#4a5568"
bright_red = "#ec7063"
bright_green = "#73c6b6"
bright_yellow = "#f8c471"
bright_blue = "#7fb3d5"
bright_magenta = "#d7bde2"
bright_cyan = "#76d7c4"
bright_white = "#f8f9fa"

[semantic]
# UI semantic colors
success = "#52be80"
warning = "#f39c12"
error = "#e74c3c"
info = "#5dade2"
hint = "#48c9b0"

[ui]
# Component-specific colors
selection_bg = "#2c3e50"
selection_fg = "#ecf0f1"
border = "#34495e"
border_focused = "#5dade2"
accent = "#5dade2"
accent_secondary = "#48c9b0"

[sidebar]
background = "#0f1419"
foreground = "#e0e0e0"
widget_border = "#34495e"
active_widget = "#5dade2"
inactive_widget = "#7f8c8d"

[prompt]
user = "#48c9b0"
host = "#5dade2"
directory = "#f39c12"
git_clean = "#52be80"
git_dirty = "#e74c3c"
symbol = "#e0e0e0"

[file_manager]
directory = "#5dade2"
executable = "#52be80"
link = "#48c9b0"
archive = "#f39c12"
image = "#bb8fce"
video = "#e74c3c"
audio = "#ec7063"
document = "#85c1e9"

[syntax]
# Code syntax highlighting
comment = "#7f8c8d"
keyword = "#5dade2"
string = "#52be80"
number = "#f39c12"
function = "#48c9b0"
variable = "#e0e0e0"
type = "#bb8fce"
operator = "#ec7063"
```

---

## Color Palette Structure

### Color Definition Formats

WilderedOS themes support multiple color formats for flexibility:

**Hexadecimal RGB:**
```ini
color = "#5dade2"
```

**RGB Values:**
```ini
color = "rgb(93, 173, 226)"
```

**Named Colors (X11):**
```ini
color = "dodgerblue"
```

**Color References:**
```ini
accent = "${blue}"  # References [ansi] blue
```

### Color Variables

Themes can define reusable color variables:

```ini
[variables]
primary = "#5dade2"
secondary = "#48c9b0"
background_dark = "#1a1a2e"
background_light = "#f8f9fa"

[ui]
accent = "${primary}"
border_focused = "${primary}"
selection_bg = "${background_dark}"
```

---

## Theme Application

### Terminal Emulator Integration

WilderedOS generates terminal emulator configuration from theme files.

**For fbterm:**
```bash
# Generated from theme
export FBTERM_BACKGROUND_COLOR=0
export FBTERM_FOREGROUND_COLOR=7
# ... color palette settings
```

**For tmux:**
```tmux
# Generated tmux theme fragment
set -g status-bg "#1a1a2e"
set -g status-fg "#e0e0e0"
set -g window-status-current-style "bg=#5dade2,fg=#1a1a2e"
```

**For bash/zsh prompt:**
```bash
# Generated prompt colors
PROMPT_USER_COLOR="\033[38;2;72;201;176m"
PROMPT_DIR_COLOR="\033[38;2;243;156;18m"
```

### Application Integration

Custom WilderedOS applications read theme from a unified API:

```bash
# Get current theme colors
source /opt/wilderedos/lib/theme.sh

# Access colors
echo "${THEME_PRIMARY}"
echo "${THEME_SUCCESS}"
echo "${THEME_BG}"
```

**Python API:**
```python
from wilderedos.theme import Theme

theme = Theme.current()
print(theme.colors.primary)
print(theme.colors.success)
print(theme.ui.sidebar.background)
```

---

## Creating Custom Themes

### Theme Creation Workflow

**1. Start from Template:**
```bash
# Copy existing theme as base
cp /opt/wilderedos/share/themes/default-dark.theme \
   ~/.config/wilderedos/themes/my-theme.theme
```

**2. Edit Colors:**
```bash
# Edit theme file
nano ~/.config/wilderedos/themes/my-theme.theme

# Update [meta] section with your info
# Modify colors in each section
```

**3. Test Theme:**
```bash
# Preview without applying
wilderedos-theme preview my-theme

# Apply temporarily (current session)
wilderedos-theme apply my-theme --temporary
```

**4. Apply Permanently:**
```bash
# Set as default theme
wilderedos-theme apply my-theme

# Reload all terminals
wilderedos-theme reload
```

### Theme Validation

The theme system validates themes before applying:

```bash
wilderedos-theme validate my-theme.theme
```

**Checks:**
- All required sections present
- Color values valid (hex, rgb, or named)
- No undefined variable references
- Contrast ratios meet readability standards
- Transparency values in valid range

### Color Picker Tool

WilderedOS includes a TUI color picker:

```bash
wilderedos-color-picker
```

**Features:**
- Visual color selection in terminal
- Shows color preview with text samples
- Displays hex, RGB, and ANSI values
- Saves to clipboard or theme file
- Contrast checker for accessibility

---

## Theme Repository

### Community Themes

Users can share themes through the WilderedOS theme repository:

```bash
# Browse available themes
wilderedos-theme browse

# Download theme
wilderedos-theme install nord

# Update all themes
wilderedos-theme update
```

### Theme Repository Structure

```
https://themes.wilderedos.org/
├── official/
│   ├── liquid-glass.theme
│   ├── dark-mode.theme
│   └── light-mode.theme
├── community/
│   ├── nord.theme
│   ├── dracula.theme
│   ├── gruvbox.theme
│   ├── tokyo-night.theme
│   └── ...
└── seasonal/
    ├── autumn.theme
    ├── winter.theme
    └── spring.theme
```

### Theme Submission

Contributing themes to the repository:

```bash
# Package your theme
wilderedos-theme package my-theme.theme

# Submit to repository
wilderedos-theme submit my-theme.wtf  # WilderedOS Theme File
```

**Requirements:**
- Metadata complete (name, author, version, description)
- All required colors defined
- Screenshot or preview included
- Passes validation checks
- License specified (preferably MIT or CC0)

---

## Live Theme Switching

### Hot Reload Capability

WilderedOS supports changing themes without restarting:

```bash
# Switch theme instantly
wilderedos-theme switch dracula

# All running terminals update automatically
# Sidebar and TUI apps refresh
# No session interruption
```

### Implementation

**Theme Watcher Service:**
```bash
# Systemd user service monitors theme changes
systemctl --user status wilderedos-theme-watcher

# Broadcasts theme change signal
# All WilderedOS components listen for signal
# Each component reloads its colors
```

**Signal Handling:**
```bash
# Applications receive SIGUSR1 when theme changes
trap 'reload_theme' SIGUSR1

reload_theme() {
    source /opt/wilderedos/lib/theme.sh
    redraw_interface
}
```

---

## Default Themes

### Liquid Glass (Default Dark)

The signature WilderedOS theme featuring semi-transparent backgrounds, cool blue and cyan accents, soft contrast for extended viewing, and subtle blur effects when supported.

**Color Palette:**
- Background: `#1a1a2e` (15% transparent)
- Foreground: `#e0e0e0`
- Primary Accent: `#5dade2` (Cool Blue)
- Secondary Accent: `#48c9b0` (Teal/Cyan)
- Success: `#52be80` (Mint Green)
- Warning: `#f39c12` (Amber)
- Error: `#e74c3c` (Soft Red)

### Crystal Light (Default Light)

Light mode variant with warm tones.

**Color Palette:**
- Background: `#f8f9fa` (5% transparent)
- Foreground: `#2c3e50`
- Primary Accent: `#3498db`
- Secondary Accent: `#1abc9c`
- Success: `#27ae60`
- Warning: `#e67e22`
- Error: `#c0392b`

### Nord

Popular cool-toned theme port.

**Color Palette:**
- Background: `#2e3440`
- Foreground: `#d8dee9`
- Frost colors: `#8fbcbb`, `#88c0d0`, `#81a1c1`, `#5e81ac`
- Aurora colors: `#bf616a`, `#d08770`, `#ebcb8b`, `#a3be8c`, `#b48ead`

### Dracula

High contrast vibrant theme port.

**Color Palette:**
- Background: `#282a36`
- Foreground: `#f8f8f2`
- Purple: `#bd93f9`
- Pink: `#ff79c6`
- Green: `#50fa7b`
- Yellow: `#f1fa8c`

### Gruvbox

Retro warm theme port.

**Color Palette:**
- Background: `#282828`
- Foreground: `#ebdbb2`
- Warm accent tones
- High readability focus

---

## Theme Configuration Commands

### Quick Reference

```bash
# List installed themes
wilderedos-theme list

# Show current theme
wilderedos-theme current

# Preview theme without applying
wilderedos-theme preview <theme-name>

# Apply theme
wilderedos-theme apply <theme-name>

# Reload current theme (after editing)
wilderedos-theme reload

# Reset to default
wilderedos-theme reset

# Export current theme
wilderedos-theme export my-custom-theme.theme

# Validate theme file
wilderedos-theme validate <theme-file>

# Browse online themes
wilderedos-theme browse

# Install from repository
wilderedos-theme install <theme-name>

# Update all themes
wilderedos-theme update

# Remove theme
wilderedos-theme remove <theme-name>

# Edit current theme
wilderedos-theme edit

# Create new theme from template
wilderedos-theme create <theme-name> --base dark|light
```

---

## Advanced Theme Features

### Time-Based Theme Switching

Automatically switch between themes based on time of day:

```bash
# Configure automatic switching
wilderedos-theme auto-switch \
    --day liquid-light \
    --night liquid-glass \
    --sunrise 06:00 \
    --sunset 18:00
```

### Conditional Theming

Apply different themes based on context:

```bash
# SSH sessions use high-contrast theme
if [ -n "$SSH_CONNECTION" ]; then
    wilderedos-theme apply high-contrast --temporary
fi

# Different theme for presentations
wilderedos-theme apply presentation --temporary
```

### Theme Animations

Smooth transitions between themes:

```ini
[transitions]
enabled = true
duration = 300  # milliseconds
easing = "ease-in-out"
```

### Color Temperature Adjustment

Built-in blue light filter:

```bash
# Warm colors for evening use
wilderedos-theme temperature warm

# Reset to theme defaults
wilderedos-theme temperature reset
```

---

## Accessibility Considerations

### Contrast Validation

All themes must meet WCAG AA contrast standards:

- Normal text: 4.5:1 minimum
- Large text: 3:1 minimum
- UI components: 3:1 minimum

The theme validator automatically checks these ratios:

```bash
wilderedos-theme validate --check-contrast my-theme.theme
```

### High Contrast Mode

System-wide high contrast override:

```bash
# Enable high contrast
wilderedos-theme accessibility high-contrast on

# Disable
wilderedos-theme accessibility high-contrast off
```

### Colorblind Modes

Alternative color schemes for different types of colorblindness:

```bash
# Deuteranopia (red-green)
wilderedos-theme accessibility colorblind deuteranopia

# Protanopia (red-green)
wilderedos-theme accessibility colorblind protanopia

# Tritanopia (blue-yellow)
wilderedos-theme accessibility colorblind tritanopia

# Reset
wilderedos-theme accessibility colorblind off
```

---

## Integration with System Components

### Sidebar Theming

The sidebar companion automatically adopts theme colors:

```ini
[sidebar]
# Override sidebar specifically
background = "${background}"  # Inherit from terminal
widget_background = "#0f1419"  # Slightly darker
border = "${border_focused}"
text = "${foreground}"
```

### File Manager Colors

File type colors come from theme:

```bash
# In file manager, colors are theme-aware
Directories:  ${file_manager.directory}
Executables:  ${file_manager.executable}
Archives:     ${file_manager.archive}
```

### Prompt Customization

Shell prompts use theme colors:

```bash
# PS1 generated from theme
PS1="${THEME_PROMPT_USER}\u${THEME_RESET}@${THEME_PROMPT_HOST}\h ${THEME_PROMPT_DIR}\w${THEME_RESET} \$ "
```

---

## Performance Considerations

### Theme Caching

WilderedOS caches compiled theme data for performance:

```
~/.cache/wilderedos/themes/
├── liquid-glass.cache
└── current.cache
```

Cache is regenerated when theme file changes.

### Minimal Overhead

Theme switching has negligible performance impact:
- Theme reload: <50ms
- Color updates: broadcasted via signals
- No application restarts required

---

## Future Enhancements

### Dynamic Wallpaper Integration

Extract colors from wallpaper images to generate themes automatically.

### AI-Generated Themes

Use AI to generate harmonious color schemes based on user preferences.

### Synchronized Theming

Sync theme across multiple machines with WilderedOS Cloud.

### Per-Application Theming

Allow different themes for different applications or workspaces.

---

## Conclusion

The WilderedOS theming system provides powerful flexibility for color customization while maintaining consistency across all components. With support for custom themes, live switching, and a growing community repository, users can personalize their terminal environment to match their aesthetic preferences and workflow needs.

The centralized theme architecture ensures that when colors need to change—whether for aesthetic updates, accessibility needs, or personal preference—the entire system updates cohesively without requiring code modifications.

---

**Ready to customize your colors?**

```bash
wilderedos-theme list
wilderedos-theme apply <your-choice>
```

**Create your own theme:**

```bash
wilderedos-theme create my-awesome-theme --base dark
wilderedos-theme edit my-awesome-theme
```
