# WilderedOS Architecture

<div align="center">

**_Technical Overview of the Terminal-Based Operating System_**

</div>

---

## Table of Contents
- [Overview](#overview)
- [Design Philosophy](#design-philosophy)
- [System Architecture](#system-architecture)
- [Core Components](#core-components)
- [Terminal Environment](#terminal-environment)
- [Custom Applications](#custom-applications)
- [File System Structure](#file-system-structure)
- [Smart Storage System](#smart-storage-system)
- [Package Management](#package-management)
- [Build System](#build-system)
- [Security Architecture](#security-architecture)
- [Performance Optimizations](#performance-optimizations)

---

## Overview

WilderedOS is a terminal-based Linux distribution built on Ubuntu that provides a complete desktop experience through the command line interface. Unlike traditional GUI-based distributions, WilderedOS leverages the power and efficiency of terminal user interfaces (TUI) to create a lightweight, fast, and highly customizable operating system that runs exceptionally well on low-end hardware.

**Key Architectural Principles:**
- Everything runs in the terminal - no X11 or Wayland required
- Custom TUI applications replace traditional GUI apps
- Minimal resource footprint through careful component selection
- Modular design allowing easy customization and extension
- Ubuntu LTS base for stability and package availability

---

## Design Philosophy

**Terminal-First Approach:**
WilderedOS embraces the terminal as the primary interface rather than treating it as a fallback or power-user tool. This decision provides several advantages: dramatically reduced memory usage (no desktop environment overhead), faster system performance, better responsiveness on old hardware, lower power consumption for laptops, and ssh-friendly remote access by design.

**Aesthetic Without Bloat:**
The "liquid glass feel" mentioned in project documentation is achieved through terminal transparency, blur effects, and carefully designed color schemes rather than heavy graphical rendering. Modern terminal emulators support true transparency, blur, and sophisticated color palettes that create beautiful interfaces without GPU-intensive compositing.

**Progressive Enhancement:**
WilderedOS follows a progressive enhancement model with editions building on each other. The Base Edition provides essential functionality with absolute minimal resource requirements. The Standard Edition adds convenience features like the sidebar companion and Smart Storage. Test and Full editions layer additional applications while maintaining the lightweight terminal foundation.

---

## System Architecture

### High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         User Space                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │ Terminal     │  │ Sidebar      │  │ Custom TUI Apps      │  │
│  │ Emulator     │  │ Companion    │  │ (File Manager,       │  │
│  │ (Custom)     │  │ (tmux pane)  │  │  Settings, etc.)     │  │
│  └──────────────┘  └──────────────┘  └──────────────────────┘  │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │            WilderedOS Custom Layer                        │  │
│  │  • Smart Storage Daemon                                   │  │
│  │  • Archive Manager                                        │  │
│  │  • Quick Search Indexer                                   │  │
│  │  • Window/Session Manager                                 │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │               Shell Environment (Bash/Zsh)                │  │
│  │  • Custom prompts and themes                              │  │
│  │  • Keyboard shortcuts and bindings                        │  │
│  │  • Command aliases and functions                          │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────────┐
│                    Ubuntu Base System                            │
│  • Systemd (init system)                                         │
│  • APT package manager                                           │
│  • Core utilities and libraries                                  │
│  • Linux kernel with framebuffer support                         │
└─────────────────────────────────────────────────────────────────┘
```

### Boot Process

1. **GRUB Bootloader** - Custom themed bootloader with WilderedOS branding
2. **Kernel Loading** - Linux kernel initializes hardware
3. **Systemd Init** - System services start in parallel
4. **WilderedOS Services** - Custom daemons (Smart Storage, Archive Manager) launch
5. **Login Manager** - Lightweight login prompt (custom or built on getty)
6. **Shell Initialization** - User shell loads with custom configuration
7. **Welcome Screen** - ASCII art display with system information
8. **Terminal Environment** - Full WilderedOS interface available

---

## Core Components

### Terminal Emulator

WilderedOS uses a customized terminal emulator as its primary interface. We build upon existing robust terminal emulators rather than creating from scratch:

**Preferred Base: fbterm or kmscon**
These framebuffer-based terminals run directly on the Linux console without requiring X11 or Wayland, providing true transparency effects, 256-color or true-color support, Unicode and emoji rendering, and custom font support including icon fonts.

**Fallback: tmux + standard terminal**
For maximum compatibility, the system can run entirely within tmux sessions on standard virtual terminals, allowing split panes for the sidebar companion, session persistence across disconnections, and easy remote access via ssh.

**Terminal Configuration:**
Custom configuration files set default colors matching the liquid glass aesthetic, transparency levels optimized for readability, keyboard shortcuts for common operations, font selections including patched Nerd Fonts for icons, and cursor styles and behavior.

### Shell Environment

**Default Shell: Bash with Zsh option**
Bash provides maximum compatibility while Zsh offers enhanced features for power users. Both are configured with custom prompts using Powerline or Starship for beautiful, informative command lines.

**Custom Prompt Features:**
- Display current directory with Smart Storage category indicators
- Git integration showing repository status
- System resource indicators (CPU, memory, disk usage)
- Custom color schemes matching the liquid glass aesthetic
- Context-aware prompts that adapt to different situations

**Shell Extensions:**
- Auto-suggestions based on command history
- Syntax highlighting for commands
- Advanced tab completion with descriptions
- Directory jumping with frecency algorithms (z or autojump)
- Command aliasing for WilderedOS-specific operations

### Sidebar Companion

The sidebar companion is implemented as a persistent tmux pane or a custom daemon that provides at-a-glance information and quick actions.

**Implementation Approach:**
Use tmux with a dedicated side pane running a custom script that continuously updates to display widgets, system monitors, and shortcuts. The script uses terminal escape sequences to create a semi-interactive interface.

**Sidebar Features:**
- System resource monitoring (CPU, RAM, disk, network)
- Quick application launcher with fuzzy search
- Smart Storage category overview
- Recent files and directory quick-access
- Notification center for system alerts
- Calendar and clock widgets
- Customizable widget arrangement

**Technical Implementation:**
The sidebar runs as a continuous loop in bash or python, updating at configurable intervals (default 2 seconds for resource monitors, 30 seconds for less time-sensitive widgets). It uses ncurses or direct terminal escape codes for rendering, with click handling through terminal mouse support when available.

---

## Terminal Environment

### Color Scheme and Theming

**Dynamic Theme System:**
WilderedOS uses a centralized theming system where colors are defined in external theme configuration files rather than hardcoded in components. This allows for easy customization, theme switching, and community-contributed themes.

**Theme Architecture:**
All colors are loaded from theme files located in `/opt/wilderedos/share/themes/` with user customizations in `~/.config/wilderedos/`. The system supports live theme switching without requiring application restarts.

**Default Theme (Liquid Glass):**
The signature "liquid glass" aesthetic comes from the default theme featuring semi-transparent backgrounds, cool blue and cyan accents, and carefully balanced contrast ratios. However, users can switch to any theme instantly.

**See [THEMING.md](THEMING.md) for complete theming system documentation**, including:
- How to create custom themes
- Available default themes (Liquid Glass, Nord, Dracula, Gruvbox, etc.)
- Live theme switching commands
- Community theme repository
- Accessibility and colorblind modes

**Terminal Transparency:**
Transparency levels are defined per-theme and configurable. Themes specify transparency percentages (0-100%) and blur settings. Users can override transparency through theme configuration or the settings TUI.

### Keyboard-Driven Interface

WilderedOS is designed for keyboard efficiency with minimal need for mouse interaction.

**Global Shortcuts:**
- `Super + Enter` - New terminal window/tab
- `Super + D` - Application launcher
- `Super + Shift + Q` - Close current window
- `Super + 1-9` - Switch to workspace/tmux window
- `Super + Tab` - Cycle through windows
- `Super + F` - File manager
- `Super + S` - Settings
- `Super + Space` - Quick Search

**Text Navigation:**
All interfaces support vim-style navigation (hjkl) as well as arrow keys for accessibility.

### Font Configuration

**Primary Font: JetBrains Mono or Fira Code**
Monospace fonts optimized for terminal use with programming ligatures support, excellent Unicode coverage, and clear distinction between similar characters.

**Icon Font: Nerd Font Patched Version**
Patched fonts include icons from Font Awesome, Material Design Icons, and other icon sets, allowing TUI applications to display beautiful icons without requiring graphical rendering.

**Font Rendering:**
Fonts are rendered with antialiasing and proper hinting for crisp display at various sizes. Configuration supports per-user font preferences.

---

## Custom Applications

### File Manager (WildFiles)

A custom or heavily customized TUI file manager serves as the primary file system navigator.

**Based On: ranger or nnn with extensive customization**

**Features:**
- Three-column Miller view (parent directory, current directory, preview)
- File preview supporting text, images (ASCII art conversion), PDFs (text extraction), and code with syntax highlighting
- Bulk operations with visual mode
- Integrated with Smart Storage for category-aware navigation
- Bookmark system for frequent directories
- Archive extraction and creation
- Search integration with Quick Search system
- Custom actions for file types

**Smart Storage Integration:**
The file manager displays Smart Storage categories as special virtual directories, shows category badges on files and folders, provides quick category assignment and reassignment, and displays archive status for unused applications.

### Settings Manager (WildSettings)

Centralized TUI for system configuration replacing scattered config files.

**Implementation: Custom Python/Bash TUI using dialog or whiptail**

**Categories:**
- Appearance (colors, transparency, fonts)
- Sidebar configuration
- Smart Storage rules
- Archive settings
- Keyboard shortcuts
- Network settings
- User accounts
- System updates
- Application management

**Features:**
- Hierarchical menu system
- Search functionality to find settings quickly
- Reset to defaults option
- Import/export configuration profiles
- Live preview where applicable
- Validation to prevent invalid configurations

### Application Launcher (WildLaunch)

Fast, fuzzy-searching application launcher.

**Implementation: rofi-like TUI or custom fzf-based solution**

**Features:**
- Fuzzy search across installed applications
- Recent applications prioritized
- Application categories from Smart Storage
- Keyboard-only operation
- Launch with arguments
- Favorite/pinned applications
- Usage statistics for smart ordering
- Plugin system for custom actions

### Quick Search (WildSearch)

System-wide file and content search tool.

**Implementation: Custom frontend to existing search engines (locate, ripgrep, fd)**

**Features:**
- Instant-as-you-type results
- File content search with context
- Wildcard patterns (folder:date:10/10/2024)
- Smart filters by type, date, size, category
- Recent searches history
- Search within search results
- Integration with file manager for result navigation

### Text Editor (WildEdit)

While users can choose their preferred editor, WilderedOS includes a configured default.

**Options: nano (beginner-friendly) or neovim (power users)**

**Customization:**
- Syntax highlighting for all common languages
- Line numbers and column indicators
- Custom key bindings for common operations
- Integration with file manager and other tools
- Theme matching the liquid glass aesthetic

### Web Browser Integration

**Terminal-Based Browsers:**
- w3m or lynx for lightweight web browsing
- Custom start page with bookmarks and quick links
- Integration with application launcher

**Pinned Web Applications:**
Each pinned website gets a dedicated shell script that launches the browser in a new tmux window with that specific URL, creating an app-like experience. Scripts include custom window titles and can be launched from the application launcher.

---

## File System Structure

### WilderedOS-Specific Directories

```
/opt/wilderedos/
├── bin/                    # Custom WilderedOS commands and scripts
├── lib/                    # Shared libraries for WilderedOS components
├── share/
│   ├── themes/            # Color schemes and visual themes
│   ├── ascii-art/         # ASCII art assets including boot logo
│   ├── templates/         # Configuration templates
│   └── presets/           # Application preset definitions
├── etc/
│   ├── wilderedos.conf    # Main configuration file
│   ├── sidebar.conf       # Sidebar companion settings
│   ├── storage.conf       # Smart Storage rules
│   └── archive.conf       # Archive system configuration
└── var/
    ├── cache/             # Temporary files and caches
    ├── logs/              # WilderedOS component logs
    └── storage/           # Smart Storage metadata database
```

### User Configuration

```
~/.config/wilderedos/
├── theme.conf             # User's color and appearance preferences
├── shortcuts.conf         # Custom keyboard shortcuts
├── sidebar/
│   ├── widgets.conf       # Enabled widgets and order
│   └── layout.conf        # Sidebar size and position
├── storage/
│   ├── categories.conf    # Custom Smart Storage categories
│   └── rules.conf         # User-defined categorization rules
└── applications/
    ├── favorites.list     # Pinned/favorite applications
    └── hidden.list        # Hidden applications

~/.local/share/wilderedos/
├── search-index/          # Quick Search index database
├── app-usage/             # Application usage statistics
└── archived-apps/         # Metadata for archived applications
```

---

## Smart Storage System

Smart Storage is one of WilderedOS's signature features, automatically organizing files and applications by category.

### Architecture

**Components:**
1. **Categorization Engine** - Analyzes applications and files to determine categories
2. **Metadata Database** - SQLite database storing category assignments and rules
3. **File System Watcher** - Monitors for new applications and file changes
4. **Virtual Directory Layer** - Presents category-based views in file manager
5. **Rule Engine** - Applies user-defined and system rules for categorization

### Categories

**Default Application Categories:**
- Development (IDEs, compilers, version control)
- Productivity (office suites, note-taking, calculators)
- Internet (browsers, email, chat, torrent clients)
- Multimedia (media players, editors, graphics tools)
- Games (entertainment software)
- System (configuration tools, system monitors)
- Utilities (file managers, text editors, archives)

**File Categories:**
- Documents (text, PDFs, spreadsheets)
- Media (images, audio, video)
- Code (source files by language)
- Archives (compressed files)
- Downloads (files from browsers)

### Categorization Logic

**Application Detection:**
Applications are categorized based on multiple signals:
- Desktop file categories (if present)
- Binary name pattern matching
- Package descriptions from apt
- User-defined rules
- Machine learning suggestions (future enhancement)

**File Detection:**
Files are categorized by MIME type, extension, content analysis for ambiguous files, and directory context.

### Implementation

The Smart Storage daemon runs as a systemd service, monitoring the file system and updating the metadata database. The file manager queries this database to display category badges and virtual directories.

**Database Schema:**
```sql
CREATE TABLE applications (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    path TEXT NOT NULL,
    category TEXT,
    last_used TIMESTAMP,
    use_count INTEGER DEFAULT 0,
    archived BOOLEAN DEFAULT 0
);

CREATE TABLE files (
    id INTEGER PRIMARY KEY,
    path TEXT NOT NULL UNIQUE,
    category TEXT,
    mime_type TEXT,
    size INTEGER,
    modified TIMESTAMP
);

CREATE TABLE rules (
    id INTEGER PRIMARY KEY,
    pattern TEXT NOT NULL,
    category TEXT NOT NULL,
    priority INTEGER DEFAULT 0,
    type TEXT CHECK(type IN ('app', 'file'))
);
```

---

## Archive Apps Feature

Applications that haven't been used in a configurable period (default 30 days) are automatically archived to save disk space.

### Archive Process

**Detection:**
The Smart Storage daemon tracks application launches by monitoring process creation. Applications with last_used timestamps older than the threshold are flagged for archiving.

**Archiving Steps:**
1. User receives notification about pending archive operations
2. User can defer or customize archive decisions
3. Application binaries and libraries are compressed
4. Application remains in launcher with "archived" badge
5. Desktop files preserved but marked as archived
6. Metadata retained in Smart Storage database

**Restoration:**
When user attempts to launch archived application, the system automatically decompresses required files and launches the application with minimal delay (typically 2-5 seconds for first launch after restoration).

### Implementation

**Archive Storage:**
```
/var/lib/wilderedos/archives/
├── applications/
│   ├── firefox.tar.zst
│   ├── libreoffice.tar.zst
│   └── ...
└── metadata/
    ├── firefox.json
    └── ...
```

**Metadata JSON Structure:**
```json
{
  "name": "firefox",
  "version": "120.0",
  "archived_date": "2024-11-15T10:30:00Z",
  "original_size": 245000000,
  "compressed_size": 89000000,
  "paths": [
    "/usr/bin/firefox",
    "/usr/lib/firefox/*"
  ],
  "restore_time_estimate": 3.2
}
```

---

## Package Management

### APT Integration

WilderedOS uses standard Ubuntu APT repositories plus custom WilderedOS repositories for custom packages.

**Repository Structure:**
```
deb https://packages.wilderedos.org/ubuntu/ jammy main
deb https://packages.wilderedos.org/ubuntu/ jammy universe
```

**Custom Packages:**
- wilderedo
