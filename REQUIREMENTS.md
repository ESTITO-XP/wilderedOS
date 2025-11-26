# WilderedOS System Requirements

<img width="1920" height="1080" alt="y" src="https://github.com/user-attachments/assets/b6be330d-e7a9-4f00-9f59-56137a4746cc" />


**_Designed to run smoothly on both modern and older hardware_**
</div>

---

## Table of Contents
- [Minimum Requirements](#minimum-requirements)
- [Recommended Specifications](#recommended-specifications)
- [Optimal Performance Specifications](#optimal-performance-specifications)
- [Storage Requirements by Edition](#storage-requirements-by-edition)
- [Hardware Compatibility](#hardware-compatibility)
- [Network Requirements](#network-requirements)
- [Special Considerations for Low-End Devices](#special-considerations-for-low-end-devices)
- [Performance Expectations](#performance-expectations)

---

## Minimum Requirements

These specifications represent the absolute minimum needed to run WilderedOS. The system will function at this level, though you may need to disable some visual effects and limit multitasking for the best experience.

**Processor (CPU):**
- Intel Pentium 4 or AMD Athlon 64 (or equivalent)
- 1.0 GHz single-core processor
- 64-bit architecture recommended (32-bit supported on Base edition)

**Memory (RAM):**
- 1 GB RAM (Base edition)
- 2 GB RAM (Standard edition with sidebar companion)

**Storage:**
- 8 GB available disk space (Base installation)
- 15 GB for Standard edition with presets
- Additional space needed for applications and user files

**Graphics:**
- Integrated graphics with OpenGL 2.1 support
- 64 MB video memory
- Display resolution of 1024x600 or higher

**Network:**
- Not required for basic operation
- Recommended for updates and web-based features

---

## Recommended Specifications

These specifications will provide a comfortable experience with all standard features enabled, including the liquid glass UI effects and sidebar companion.

**Processor (CPU):**
- Intel Core 2 Duo or AMD Athlon X2 (or equivalent)
- 1.6 GHz dual-core processor
- 64-bit architecture

**Memory (RAM):**
- 2 GB RAM (Base edition)
- 4 GB RAM (Standard edition)
- 6 GB RAM (Full preset with pre-installed applications)

**Storage:**
- 20 GB available disk space
- SSD recommended for faster boot times and application loading
- Additional 10-20 GB recommended for Smart Storage feature

**Graphics:**
- Dedicated or integrated graphics with OpenGL 3.0 support
- 256 MB video memory
- Display resolution of 1366x768 or higher

**Network:**
- Ethernet or Wi-Fi adapter
- Broadband internet connection for optimal experience

---

## Optimal Performance Specifications

These specifications will allow you to take full advantage of all WilderedOS features, including split-screen with six windows, heavy multitasking, and all visual effects at maximum settings.

**Processor (CPU):**
- Intel Core i3/i5 or AMD Ryzen 3/5 (8th gen or newer)
- 2.0 GHz quad-core processor or better
- 64-bit architecture

**Memory (RAM):**
- 8 GB RAM or more
- 16 GB recommended for power users and developers

**Storage:**
- 40 GB available disk space
- SSD strongly recommended (NVMe preferred)
- Separate partition for user data recommended

**Graphics:**
- Dedicated graphics card with OpenGL 4.5 support
- 512 MB video memory or more
- Display resolution of 1920x1080 or higher
- Multiple monitor support available

**Network:**
- Gigabit Ethernet or Wi-Fi 5/6
- High-speed broadband for remote desktop access feature

---

## Storage Requirements by Edition

Understanding how much space each edition requires helps you plan your installation appropriately.

**Base Edition:**
The minimal installation includes only the core operating system, essential utilities, and basic applications. This edition requires approximately 8 to 10 GB of disk space. It's perfect for older computers or situations where you want maximum control over what gets installed.

**Standard Edition:**
This edition includes the sidebar companion, default icon packs, widgets, and the Smart Storage feature. You'll need between 15 to 20 GB of available space. This is the recommended edition for most users who want a balance between features and resource usage.

**Test Edition:**
The test edition comes with Wine pre-installed for running Windows applications, along with testing tools and additional utilities. This edition requires 20 to 25 GB of space initially, with room to grow as you install Windows applications.

**Full Preset Edition:**
Our most feature-complete edition includes a curated selection of pre-installed applications for productivity, development, multimedia, and web browsing. This edition needs 30 to 40 GB of available space, depending on which preset bundle you choose.

Remember that these are installation sizes. You should always allocate additional space for personal files, documents, downloads, and future application installations. We recommend having at least 50 to 100 GB total partition size for comfortable long-term use.

---

## Hardware Compatibility

WilderedOS has been tested on a wide range of hardware to ensure broad compatibility.

**Supported Architectures:**
WilderedOS primarily supports x86_64 (64-bit) architecture, which covers the vast majority of computers manufactured in the last fifteen years. We also offer limited 32-bit (x86) support in the Base edition for truly ancient hardware, though this version lacks some modern features and will eventually be phased out.

**Processor Compatibility:**
The system works with Intel processors from the Pentium 4 era onwards, including all Core series processors (Core 2, Core i3/i5/i7/i9, and newer). AMD processors from the Athlon 64 onwards are fully supported, including all Ryzen series chips. ARM support is currently in experimental stages and not recommended for production use.

**Graphics Card Support:**
WilderedOS includes open-source drivers for Intel integrated graphics, AMD Radeon cards, and NVIDIA graphics processors. For the best experience with NVIDIA cards, you may want to install proprietary drivers after installation. Older cards may require disabling some visual effects, which can be done easily through the settings panel.

**Wireless and Network Adapters:**
Most wireless adapters from major manufacturers work out of the box. This includes Intel wireless chips, Realtek adapters, Broadcom chipsets (with some exceptions), and Atheros cards. If you encounter wireless issues, the community forums have detailed guides for troubleshooting specific models.

**Laptop-Specific Features:**
WilderedOS includes power management tools that work well with most laptops, providing battery life comparable to or better than other Linux distributions. Function keys for brightness, volume, and wireless toggles are supported on most major laptop brands including Dell, HP, Lenovo, ASUS, and Acer.

---

## Network Requirements

While WilderedOS can function without internet connectivity, certain features work best with network access.

**For Installation:**
If you're using the offline installer, no network connection is needed during installation. However, the online installer requires a stable internet connection with at least 5 Mbps download speed to fetch the latest packages.

**For Updates:**
Security patches and system updates are released weekly. A broadband connection with 10 Mbps or higher is recommended for smooth update downloads. Updates typically range from 50 MB to 500 MB depending on what's being updated.

**For Remote Desktop Access:**
The "Access your desktop from anywhere" feature requires a stable internet connection with at least 5 Mbps upload speed for acceptable performance. For smooth streaming of your desktop, 10 Mbps upload is recommended.

**For Pinned Web Applications:**
When you pin websites to your taskbar to use them as applications, you'll need internet access whenever you use those applications, since they're essentially dedicated browser windows.

---

## Special Considerations for Low-End Devices

WilderedOS has been specifically designed to breathe new life into older computers. Here's what you need to know if you're running on limited hardware.

**Memory Management:**
On systems with only 1 to 2 GB of RAM, the operating system uses intelligent memory compression and swap management to maximize available memory. You should create a swap partition that's at least equal to your RAM size, or up to twice your RAM if you plan to use hibernation. The system will automatically manage swap usage to prevent disk thrashing.

**Visual Effects:**
The beautiful liquid glass UI effects can be resource-intensive. On low-end devices, WilderedOS automatically detects your hardware capabilities and suggests disabling certain effects. You can manually control which effects are enabled through the Appearance settings. Even with all effects disabled, the interface remains clean and modern.

**Sidebar Companion:**
While the sidebar companion is incredibly useful, it does consume memory and CPU cycles. On systems with less than 2 GB of RAM, consider using the Base edition without the sidebar, or configure the sidebar to launch only when needed rather than staying resident in memory.

**Application Selection:**
Choose lightweight alternatives for common applications. WilderedOS includes lightweight web browsers, text editors, and media players that consume minimal resources. The Smart Storage feature can help by archiving applications you haven't used recently, freeing up valuable disk space and memory.

**Presets for Low-End Hardware:**
We offer a "Lite" preset specifically curated for older hardware. This preset includes only essential, lightweight applications and comes with optimized settings out of the box. Consider using this preset if you're installing on a machine with less than 4 GB of RAM or a single-core processor.

---

## Performance Expectations

Understanding what to expect from WilderedOS on different hardware helps set realistic expectations and ensures satisfaction.

**On Minimum Specifications:**
With the absolute minimum hardware, WilderedOS will boot in approximately 45 to 90 seconds depending on whether you're using a hard drive or SSD. Basic tasks like web browsing, document editing, and email work smoothly with lightweight applications. You can run two to three applications simultaneously without significant slowdown. Video playback works at 720p resolution.

**On Recommended Specifications:**
The recommended hardware provides a noticeably more responsive experience. Boot times drop to 20 to 45 seconds, and the system feels snappy during normal use. You can comfortably run five to eight applications simultaneously, including web browsers with multiple tabs. The liquid glass UI effects run smoothly, and video playback works well at 1080p. The sidebar companion operates without noticeable impact on system performance.

**On Optimal Specifications:**
With optimal hardware, WilderedOS truly shines. Boot times are typically under 20 seconds with an SSD, and the system responds instantly to user input. You can run dozens of applications simultaneously, use the split-screen feature with six windows without performance degradation, and enjoy all visual effects at maximum settings. Video editing, software development, and other demanding tasks are handled comfortably.

**Comparison with Other Systems:**
In testing, WilderedOS uses approximately 30 to 40 percent less memory than Windows 10/11 on comparable hardware, and boots 20 to 30 percent faster. Compared to other Linux distributions, WilderedOS uses slightly more resources than minimal distributions like Lubuntu but provides significantly more features out of the box. It uses considerably fewer resources than Ubuntu with GNOME or KDE Plasma while maintaining a modern, attractive interface.

---

## 🗒️ Notes

- WilderedOS is designed with flexibility in mind. If your hardware falls slightly below the minimum specifications, the system may still work, especially if you're willing to use the Base edition with minimal features enabled. We encourage you to try the live USB option, which lets you test WilderedOS without installing it to see how it performs on your specific hardware.
- The development team continuously works to improve performance and reduce resource requirements with each update. We welcome feedback from users on all types of hardware, as this helps us ensure WilderedOS remains accessible to everyone, regardless of their computer's age or specifications.
- If you have questions about whether WilderedOS will work on your specific hardware, please visit our community forums or contact our support channels. The community is friendly and helpful, and someone likely has experience running WilderedOS on hardware similar to yours.
- Requirements will also be given in the releases.

---

**Ready to install? Check out our [Installation Guide](INSTALLATION.md) to get started!**
