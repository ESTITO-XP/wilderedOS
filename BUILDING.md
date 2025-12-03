# Building WilderedOS from Source

<div align="center">

**_Complete guide to building WilderedOS ISO images_**

</div>

---

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Build Environment Setup](#build-environment-setup)
- [Quick Start](#quick-start)
- [Build Process Explained](#build-process-explained)
- [Build Configuration](#build-configuration)
- [Building Different Editions](#building-different-editions)
- [Customizing Your Build](#customizing-your-build)
- [Troubleshooting](#troubleshooting)
- [Advanced Build Options](#advanced-build-options)
- [Contributing Build Improvements](#contributing-build-improvements)

---

## Overview

WilderedOS uses a custom build system based on `debootstrap` and `live-build` to create bootable ISO images. The build system is designed to be:

- **Reproducible** - Same inputs always produce identical outputs
- **Fast** - Incremental builds with caching
- **Flexible** - Easy to customize and configure
- **Automated** - CI/CD ready with minimal manual intervention

**What gets built:**
- Bootable ISO image with GRUB bootloader
- Live USB/DVD environment for testing
- Full installation system
- Pre-configured WilderedOS environment
- Edition-specific packages and configurations

---

## Prerequisites

### Hardware Requirements

**Minimum Build System:**
- 2 CPU cores
- 4 GB RAM
- 20 GB free disk space
- x86_64 architecture

**Recommended Build System:**
- 4+ CPU cores
- 8 GB RAM
- 50 GB free disk space (for multiple editions)
- SSD for faster builds

### Software Requirements

**Host Operating System:**
- Ubuntu 22.04 LTS or newer (recommended)
- Debian 11 or newer
- Any Debian-based distribution with recent packages

**Required Packages:**
```bash
sudo apt-get install -y \
    debootstrap \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-efi \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools \
    dosfstools \
    git \
    wget \
    curl
```

**Optional but Recommended:**
```bash
sudo apt-get install -y \
    parallel \
    pv \
    zstd \
    pigz
```

### Permissions

Building ISOs requires root privileges for:
- Creating loop devices
- Mounting file systems
- chroot operations

You can either:
1. Run build scripts with `sudo`
2. Add your user to sudoers with NOPASSWD for build commands (less secure)

---

## Build Environment Setup

### 1. Clone the Repository

```bash
git clone https://github.com/ESTITO-XP/WilderedOS.git
cd WilderedOS
```

### 2. Install Dependencies

```bash
# Run the dependency installer
sudo ./build/install-dependencies.sh

# Or manually install packages listed above
```

### 3. Configure Build Environment

```bash
# Copy default configuration
cp build/config/default.conf build/config/local.conf

# Edit configuration (optional)
nano build/config/local.conf
```

### 4. Verify Setup

```bash
# Check that all dependencies are installed
./build/check-dependencies.sh

# Should output: "All dependencies satisfied"
```

---

## Quick Start

### Build Base Edition (Fastest)

```bash
# Build Base Edition ISO
sudo ./build/build.sh base

# ISO will be created in: build/output/wilderedos-base-<version>-amd64.iso
```

### Build Standard Edition

```bash
# Build Standard Edition with sidebar
sudo ./build/build.sh standard

# ISO location: build/output/wilderedos-standard-<version>-amd64.iso
```

### Build All Editions

```bash
# Build all editions sequentially
sudo ./build/build-all.sh

# ISOs in: build/output/
```

### Test Build in VM

```bash
# Quick test in QEMU (requires qemu-system-x86_64)
./build/test-iso.sh build/output/wilderedos-base-*.iso
```

---

## Build Process Explained

### Phase 1: Bootstrap

Creates a minimal Debian/Ubuntu base system using debootstrap.

```
build/bootstrap.sh
├── Download Ubuntu base packages
├── Extract to build/chroot/
├── Configure APT repositories
└── Install essential packages
```

**Time:** 5-10 minutes  
**Output:** build/chroot/ directory with base system

### Phase 2: Customization

Installs WilderedOS-specific components and configurations.

```
build/customize.sh
├── Install WilderedOS packages
├── Apply configurations
├── Install themes
├── Configure terminal environment
├── Set up sidebar (Standard+ editions)
├── Install edition-specific packages
└── Clean up unnecessary files
```

**Time:** 10-20 minutes depending on edition  
**Output:** Fully configured WilderedOS system in build/chroot/

### Phase 3: Compression

Creates compressed squashfs filesystem.

```
build/compress.sh
├── Clean temporary files
├── Remove build artifacts
├── Create squashfs image
└── Calculate checksums
```

**Time:** 5-15 minutes depending on compression level  
**Output:** build/image/filesystem.squashfs

### Phase 4: ISO Generation

Builds bootable ISO with GRUB.

```
build/make-iso.sh
├── Create ISO directory structure
├── Copy kernel and initrd
├── Install GRUB bootloader
├── Configure boot menu
├── Add filesystem.squashfs
├── Generate ISO image
└── Create checksums
```

**Time:** 2-5 minutes  
**Output:** build/output/wilderedos-<edition>-<version>-amd64.iso

### Total Build Time

- **Base Edition:** 20-40 minutes
- **Standard Edition:** 30-50 minutes
- **Full Edition:** 45-75 minutes

Times vary based on:
- Internet connection speed (package downloads)
- CPU performance (compression)
- Disk I/O speed (SSD vs HDD)
- Whether build cache exists

---

## Build Configuration

### Configuration Files

```
build/config/
├── default.conf          # Default build settings
├── local.conf           # Your local overrides (git-ignored)
├── base.conf            # Base edition specific
├── standard.conf        # Standard edition specific
├── test.conf            # Test edition specific
└── full.conf            # Full edition specific
```

### Key Configuration Options

**default.conf:**
```bash
# WilderedOS version
WILDEREDOS_VERSION="1.0.0"

# Base Ubuntu release
UBUNTU_RELEASE="jammy"  # 22.04 LTS
UBUNTU_MIRROR="http://archive.ubuntu.com/ubuntu"

# Build options
BUILD_CACHE_ENABLED=true
COMPRESSION_LEVEL=9  # 1-9, higher = smaller but slower
PARALLEL_JOBS=4      # Number of parallel jobs

# Output
OUTPUT_DIR="build/output"
ISO_PREFIX="wilderedos"

# Architecture
ARCH="amd64"  # or "i386" for 32-bit
```

### Edition-Specific Configuration

**base.conf:**
```bash
EDITION_NAME="base"
EDITION_DESCRIPTION="Minimal terminal-based system"

# Packages to install
BASE_PACKAGES="
    tmux
    bash
    nano
    vim
    w3m
    fbterm
    ranger
    fzf
"

# Themes to include
THEMES="liquid-glass crystal-light"

# Features
ENABLE_SIDEBAR=false
ENABLE_SMART_STORAGE=false
```

**standard.conf:**
```bash
EDITION_NAME="standard"
EDITION_DESCRIPTION="Full featured terminal system"

# Inherits BASE_PACKAGES and adds:
ADDITIONAL_PACKAGES="
    zsh
    neovim
    ripgrep
    fd-find
    bat
"

# Features
ENABLE_SIDEBAR=true
ENABLE_SMART_STORAGE=true
ENABLE_WIDGETS=true
```

---

## Building Different Editions

### Base Edition

Minimal installation, no sidebar, basic packages only.

```bash
sudo ./build/build.sh base
```

**Size:** ~600-800 MB ISO  
**Build Time:** 20-40 minutes

### Standard Edition

Includes sidebar companion, Smart Storage, all themes.

```bash
sudo ./build/build.sh standard
```

**Size:** ~900-1200 MB ISO  
**Build Time:** 30-50 minutes

### Test Edition

Standard + Wine for Windows application support.

```bash
sudo ./build/build.sh test
```

**Size:** ~1500-1800 MB ISO  
**Build Time:** 40-60 minutes

### Full Edition

Complete installation with all presets and applications.

```bash
sudo ./build/build.sh full
```

**Size:** ~2000-2500 MB ISO  
**Build Time:** 45-75 minutes

### 32-bit (i386) Builds

```bash
# Build 32-bit Base Edition
sudo ARCH=i386 ./build/build.sh base

# 32-bit support is limited to Base Edition only
```

---

## Customizing Your Build

### Adding Custom Packages

**Method 1: Edit package list**
```bash
# Add packages to edition config
nano build/config/custom.conf

CUSTOM_PACKAGES="
    htop
    ncdu
    tree
    git
"
```

**Method 2: Use build flag**
```bash
# Add packages at build time
sudo ./build/build.sh standard --extra-packages="htop,ncdu,tree"
```

### Adding Custom Themes

```bash
# Place custom theme in themes directory
cp my-custom.theme build/themes/

# It will be included in the build automatically
```

### Custom Configurations

```bash
# Add custom config files
build/overlay/
├── etc/
│   └── wilderedos/
│       └── custom.conf
├── opt/
│   └── wilderedos/
│       └── custom-scripts/
└── usr/
    └── local/
        └── bin/
            └── custom-tool

# Files in overlay/ are copied to the ISO during build
```

### Custom Boot Splash

```bash
# Replace ASCII art
cp my-ascii-art.txt build/assets/ascii-art.txt

# Customize GRUB menu
nano build/grub/grub.cfg
```

---

## Troubleshooting

### Build Fails: Permission Denied

**Problem:** Script exits with permission errors.

**Solution:**
```bash
# Run with sudo
sudo ./build/build.sh base

# Or give build directory proper permissions
sudo chown -R $USER:$USER build/
```

### Build Fails: Out of Disk Space

**Problem:** Build runs out of space during compression.

**Solution:**
```bash
# Clean previous builds
sudo ./build/clean.sh

# Check available space
df -h

# Free up space or use different partition
sudo ./build/build.sh base --work-dir=/path/to/larger/partition
```

### Build Fails: Package Download Errors

**Problem:** Cannot download packages from mirror.

**Solution:**
```bash
# Try different mirror
nano build/config/local.conf
UBUNTU_MIRROR="http://us.archive.ubuntu.com/ubuntu"

# Or use local mirror
UBUNTU_MIRROR="http://local-mirror.example.com/ubuntu"
```

### Build Hangs During Debootstrap

**Problem:** Build appears stuck downloading packages.

**Solution:**
```bash
# Check network connectivity
ping -c 3 archive.ubuntu.com

# Increase verbosity to see progress
sudo ./build/build.sh base --verbose

# Kill and restart build
sudo ./build/clean.sh --chroot
sudo ./build/build.sh base
```

### ISO Won't Boot in VM

**Problem:** Generated ISO fails to boot in VirtualBox/QEMU.

**Solution:**
```bash
# Verify ISO integrity
md5sum build/output/wilderedos-*.iso

# Check ISO is hybrid (boots from USB and DVD)
file build/output/wilderedos-*.iso

# Try different boot mode
# UEFI: Enable EFI in VM settings
# Legacy: Disable EFI in VM settings
```

### Build Produces Different Output Each Time

**Problem:** Builds aren't reproducible.

**Solution:**
```bash
# Enable reproducible builds
nano build/config/local.conf
REPRODUCIBLE_BUILD=true
BUILD_TIMESTAMP="2024-01-01T00:00:00Z"

# This fixes timestamps and removes build-specific metadata
```

---

## Advanced Build Options

### Parallel Builds

```bash
# Build multiple editions in parallel
sudo ./build/build-all.sh --parallel

# Or manually with GNU parallel
parallel sudo ./build/build.sh {} ::: base standard test full
```

### Incremental Builds

```bash
# Build with cache (much faster for subsequent builds)
sudo ./build/build.sh standard --incremental

# Cache is stored in build/cache/
# Reuses downloaded packages and built components
```

### Custom Kernel

```bash
# Use custom kernel version
sudo ./build/build.sh base --kernel-version=5.15.0-91

# Or use hardware enablement (HWE) kernel
sudo ./build/build.sh base --hwe-kernel
```

### Debug Build

```bash
# Build with debug symbols and logging
sudo ./build/build.sh base --debug

# Keeps intermediate files for inspection
# Creates detailed build log in build/logs/
```

### Minimal Build (Fastest)

```bash
# Skip compression, use fast settings
sudo ./build/build.sh base \
    --compression=1 \
    --skip-checksums \
    --no-cleanup

# Useful for testing builds quickly
```

---

## Contributing Build Improvements

### Running Build Tests

```bash
# Test build system without actually building
./build/test-build-system.sh

# Test specific edition config
./build/validate-config.sh standard

# Lint build scripts
shellcheck build/*.sh
```

### Adding New Edition

1. Create configuration file:
```bash
cp build/config/standard.conf build/config/mynew.conf
nano build/config/mynew.conf
```

2. Define packages and features:
```bash
EDITION_NAME="mynew"
EDITION_DESCRIPTION="My custom edition"
ADDITIONAL_PACKAGES="package1 package2"
```

3. Test build:
```bash
sudo ./build/build.sh mynew
```

4. Submit PR with new edition config

### Improving Build Speed

Common optimization areas:
- Package caching strategy
- Parallel debootstrap
- Compression algorithm selection
- squashfs optimization flags
- Overlay filesystem usage

See `build/OPTIMIZATION.md` for detailed performance tuning guide.

---

## Build System Architecture

```
build/
├── build.sh                 # Main build script
├── build-all.sh            # Build all editions
├── bootstrap.sh            # Phase 1: Bootstrap
├── customize.sh            # Phase 2: Customize
├── compress.sh             # Phase 3: Compress
├── make-iso.sh             # Phase 4: ISO generation
├── clean.sh                # Cleanup utility
├── test-iso.sh             # ISO testing in QEMU
├── install-dependencies.sh # Dependency installer
├── check-dependencies.sh   # Dependency checker
├── validate-config.sh      # Config validator
│
├── config/                 # Configuration files
│   ├── default.conf
│   ├── base.conf
│   ├── standard.conf
│   ├── test.conf
│   └── full.conf
│
├── packages/               # Package lists
│   ├── base.list
│   ├── standard.list
│   ├── test.list
│   └── full.list
│
├── scripts/                # Helper scripts
│   ├── chroot-run.sh      # Execute commands in chroot
│   ├── mount-chroot.sh    # Mount for chroot
│   ├── umount-chroot.sh   # Unmount after chroot
│   └── create-user.sh     # Create default user
│
├── overlay/                # Files to copy to ISO
│   ├── etc/
│   ├── opt/
│   └── usr/
│
├── themes/                 # Theme files
│   ├── liquid-glass.theme
│   ├── crystal-light.theme
│   └── ...
│
├── grub/                   # GRUB configuration
│   ├── grub.cfg
│   └── theme/
│
├── assets/                 # Build assets
│   ├── ascii-art.txt
│   ├── background.png
│   └── isolinux.cfg
│
├── chroot/                 # Build chroot (created during build)
├── image/                  # ISO staging (created during build)
├── cache/                  # Build cache
├── logs/                   # Build logs
└── output/                 # Final ISOs
    └── wilderedos-*.iso
```

---

## Continuous Integration

### GitHub Actions Workflow

The repository includes CI workflows that automatically build ISOs:

- **On Push to Main:** Build all editions
- **On Pull Request:** Build and test affected editions
- **On Release Tag:** Build, test, and publish ISOs

### Local CI Testing

```bash
# Run same checks as CI
./build/ci-test.sh

# Runs: shellcheck, config validation, test builds
```

---

## Additional Resources

- **Build System Documentation:** `build/README.md`
- **Optimization Guide:** `build/OPTIMIZATION.md`
- **Package Selection Guide:** `build/PACKAGES.md`
- **Troubleshooting:** `build/TROUBLESHOOTING.md`

---

## Quick Reference

```bash
# Install dependencies
sudo ./build/install-dependencies.sh

# Build Base Edition
sudo ./build/build.sh base

# Build Standard Edition
sudo ./build/build.sh standard

# Build all editions
sudo ./build/build-all.sh

# Clean build artifacts
sudo ./build/clean.sh

# Test ISO in QEMU
./build/test-iso.sh build/output/wilderedos-*.iso

# Validate configuration
./build/validate-config.sh standard

# Check dependencies
./build/check-dependencies.sh
```

---

**Ready to build? Start with Base Edition:**

```bash
sudo ./build/build.sh base
```

**Questions or issues?** Check [CONTRIBUTING.md](CONTRIBUTING.md) or open an issue on GitHub.
