# WilderedOS Installation Guide

<img width="1920" height="1080" alt="III" src="https://github.com/user-attachments/assets/dce578d4-8f5e-45da-ae44-dde16437e822" />


**_Get up and running with WilderedOS in minutes_**
</div>

---

## Table of Contents
- [Before You Begin](#before-you-begin)
- [Download WilderedOS](#download-wilderedos)
- [Creating Installation Media](#creating-installation-media)
- [Booting from Installation Media](#booting-from-installation-media)
- [Installation Methods](#installation-methods)
- [Step-by-Step Installation Process](#step-by-step-installation-process)
- [Post-Installation Setup](#post-installation-setup)
- [Optimizing for Low-End Devices](#optimizing-for-low-end-devices)
- [Dual-Boot Configuration](#dual-boot-configuration)
- [Troubleshooting Common Issues](#troubleshooting-common-issues)

---

## Before You Begin

Taking a few moments to prepare will make your installation experience smooth and trouble-free.

**Check System Requirements:**
Before downloading WilderedOS, verify that your computer meets the minimum requirements outlined in our [Requirements document](REQUIREMENTS.md). While WilderedOS is designed to work on older hardware, knowing your system's capabilities helps you choose the right edition and set appropriate expectations.

**Back Up Your Data:**
This step cannot be emphasized enough. Before proceeding with any operating system installation, back up all important files, documents, photos, and other personal data to an external drive or cloud storage service. While the installation process includes options to preserve existing data, unexpected issues can occur, and having a backup ensures your files remain safe.

**Gather Information About Your System:**
Knowing basic details about your computer helps during installation. Check what processor you have, how much RAM is installed, and how much free disk space is available. If you're planning a dual-boot setup with another operating system, note which partitions are currently in use and their sizes.

**Prepare Installation Media:**
You'll need either a USB flash drive with at least 4 GB capacity or a blank DVD if you prefer optical media. The USB drive method is faster and more convenient for most users. Note that creating installation media will erase everything on the USB drive, so make sure it doesn't contain important files.

**Ensure Stable Power:**
If you're installing on a laptop, plug it into wall power. While the installation process is relatively quick, running out of battery mid-installation can cause serious problems. Desktop users should ensure they're not at risk of power interruptions.

---

## Download WilderedOS

Visit the official WilderedOS download page to get the latest stable release. The website offers several editions tailored to different needs and hardware capabilities.

**Choosing Your Edition:**
The Base Edition provides a minimal installation perfect for very old hardware or users who want complete control over what gets installed. This edition requires the least disk space and system resources but provides only essential functionality out of the box.

The Standard Edition includes the sidebar companion, Smart Storage feature, default icon packs, and widgets. This is the recommended choice for most users, offering an excellent balance between features and resource usage. It works well on hardware meeting the recommended specifications.

The Test Edition comes with Wine pre-installed, allowing you to run Windows applications right away. This edition is ideal if you need specific Windows software or want to transition gradually from Windows to WilderedOS. It requires slightly more disk space and resources than the Standard Edition.

The Full Preset Edition includes carefully selected applications for productivity, development, multimedia, and web browsing. Choose this if you want a complete desktop experience immediately after installation, though be aware it requires more disk space and works best on hardware meeting or exceeding the recommended specifications.

**Verify Your Download:**
After downloading, verify the integrity of your ISO file using the provided checksums. The download page includes SHA256 hashes that you can compare against your downloaded file. This verification ensures your download wasn't corrupted and helps confirm you're installing genuine WilderedOS software.

---

## Creating Installation Media

Once you've downloaded the WilderedOS ISO file, you need to transfer it to a bootable USB drive or DVD.

**Using Etcher (Recommended for All Platforms):**
Balena Etcher is a free, user-friendly tool that works on Windows, macOS, and Linux. Download Etcher from the official website, install it, and launch the application. Click "Flash from file" and select your WilderedOS ISO. Insert your USB drive, and Etcher will automatically detect it. Click "Select target" to confirm your USB drive, then click "Flash" to begin the process. Etcher will write the ISO to your USB drive and verify the write was successful. The entire process typically takes five to fifteen minutes depending on USB drive speed.

**Using Rufus (Windows Users):**
Rufus is another excellent option specifically for Windows users. Download Rufus from its official website and run the executable. Insert your USB drive and select it from the Device dropdown menu. Click "SELECT" and choose your WilderedOS ISO file. Rufus will automatically configure the appropriate settings. Under "Partition scheme," select "GPT" for modern systems with UEFI or "MBR" for older systems with legacy BIOS. Click "START" to begin creating your bootable USB drive. Rufus will warn you that all data on the drive will be destroyed, so confirm you've backed up anything important before proceeding.

**Using dd Command (Linux/macOS Users):**
Advanced users comfortable with the command line can use the dd command. First, insert your USB drive and identify its device name using the lsblk or diskutil list command. Be absolutely certain you have the correct device name, as using dd with the wrong device can destroy data on your hard drive. Unmount the USB drive if it's automatically mounted, then run the command: sudo dd if=/path/to/wilderedos.iso of=/dev/sdX bs=4M status=progress. Replace /path/to/wilderedos.iso with your actual ISO file path and /dev/sdX with your USB drive's device name. The status=progress option shows you the progress as it writes. This process can take ten to thirty minutes depending on your USB drive speed.

**Creating a DVD:**
If you prefer optical media or your computer lacks USB boot capability, burn the ISO to a DVD using your operating system's built-in disc burning tool or software like ImgBurn on Windows. Use the "burn image" or "write ISO" option rather than simply copying the file. Use a DVD-R or DVD+R rather than a rewritable disc for better compatibility.

---

## Booting from Installation Media

With your installation media ready, you need to configure your computer to boot from it instead of your hard drive.

**Accessing Boot Menu or BIOS:**
Restart your computer with the USB drive inserted or DVD in the drive. As your computer starts, you'll see a brief message indicating which key to press to access the boot menu or BIOS setup. This key varies by manufacturer but is commonly F2, F12, Delete, or Escape. You need to press this key repeatedly during the very early stages of startup, typically when you see the manufacturer's logo.

**Using the Boot Menu (Easier Method):**
The boot menu allows you to select which device to boot from for this session only without changing permanent settings. When you access the boot menu, you'll see a list of available boot devices. Use arrow keys to highlight your USB drive or DVD, then press Enter to boot from it. The device might be listed by brand name or generic description like "USB Storage Device" or "UEFI USB."

**Changing BIOS Boot Order (If Boot Menu Doesn't Work):**
Some computers require you to enter BIOS setup and change the boot order. Navigate to the "Boot" tab using arrow keys. Look for "Boot Priority," "Boot Order," or similar options. Move your USB drive or DVD drive to the top of the list so it boots first. Save changes and exit, which is typically done by pressing F10 or selecting "Save and Exit" from a menu.

**Secure Boot Considerations:**
Modern computers with Windows 8 or later often have Secure Boot enabled. WilderedOS includes signed bootloaders that work with Secure Boot, but if you encounter boot issues, you may need to temporarily disable Secure Boot in your BIOS settings. This option is usually found under the "Security" or "Boot" tab in BIOS setup.

---

## Installation Methods

WilderedOS offers two primary installation approaches to suit different needs and situations.

**Try WilderedOS (Live Mode):**
When you boot from the installation media, you'll first see a menu offering to try WilderedOS without installing. This live mode loads the entire operating system into memory and runs without touching your hard drive. It's perfect for testing hardware compatibility, exploring features, and getting comfortable with the interface before committing to installation. You can use the web browser, test applications, and verify that your wireless adapter, graphics card, and other hardware work properly. Performance in live mode is slower than an installed system, especially if you're running from DVD or a slow USB drive, but it gives you a good sense of what to expect.

**Direct Installation:**
If you're confident about installing WilderedOS, you can choose to install directly from the boot menu. This approach is faster since it skips loading the live environment first. However, we generally recommend trying live mode first, especially on older hardware, to confirm everything works as expected.

---

## Step-by-Step Installation Process

The WilderedOS installer uses a clean, intuitive interface that guides you through each step. The entire installation process typically takes fifteen to forty-five minutes depending on your hardware speed and the edition you're installing.

**Welcome Screen:**
After booting from your installation media and selecting "Install WilderedOS," you'll see a welcome screen. Select your preferred language for the installation process. This choice also sets the default system language, though you can change it later. Click "Continue" to proceed to the next step.

**Keyboard Layout Selection:**
Choose your keyboard layout from the list. The installer attempts to detect your layout automatically based on your language selection, but you should verify it's correct. You can test the layout by typing in the text box provided. If you use multiple keyboard layouts, you can add additional layouts later through system settings. Click "Continue" when satisfied with your selection.

**Network Connection:**
If the installer detects available wireless networks, it will prompt you to connect. While you can skip this step and install offline, connecting to the internet allows the installer to download the latest updates during installation, saving you time later. Select your wireless network from the list, enter the password if required, and wait for the connection to establish. Wired ethernet connections are automatically detected and connected.

**Edition and Software Selection:**
This screen lets you choose which WilderedOS edition to install and whether to include additional software. If you downloaded the Standard Edition ISO, you'll see options to add or remove certain components. For low-end devices, consider deselecting components like the sidebar companion or certain visual effects to save resources. You can always enable these features later if your system handles the base installation well. For very old hardware, the Base Edition with minimal selections provides the best performance.

**Installation Type:**
The installer presents several installation options. "Erase disk and install WilderedOS" is the simplest choice, replacing everything on your hard drive with WilderedOS. Use this option if the computer is dedicated to WilderedOS or if you're replacing an existing system you no longer need.

"Install WilderedOS alongside existing operating system" enables dual-booting, allowing you to keep your current operating system and choose which to use at startup. The installer automatically detects existing operating systems and suggests a partition layout. You can adjust the slider to allocate more or less space to WilderedOS.

"Something else" provides manual partitioning control for advanced users who want specific partition configurations, separate home partitions, or complex dual-boot setups.

**Partition Configuration (Manual Partitioning):**
If you chose manual partitioning, you'll see a list of all drives and partitions. For a basic WilderedOS installation, you need at least a root partition (mount point /). We strongly recommend creating a swap partition, especially on systems with limited RAM. The swap partition should be at least equal to your RAM size, or twice your RAM if you plan to use hibernation.

For better organization, consider creating a separate home partition (mount point /home). This separates system files from user files, making system upgrades and reinstallations easier since your personal data remains untouched on the home partition.

Create a new partition by selecting free space and clicking the plus icon. Choose the partition size, select "Ext4 journaling file system" as the type for root and home partitions, and set the appropriate mount point. For swap, select "swap area" as the type.

**Partition Size Recommendations for Low-End Devices:**
On systems with limited disk space, allocate at least 15 to 20 GB for the root partition if installing Standard Edition, or 10 to 12 GB for Base Edition. Create a swap partition matching your RAM size. Any remaining space can go to a home partition for user files. If space is extremely tight, you can skip the separate home partition and use the root partition for everything, though this is less ideal for system maintenance.

**Location and Time Zone:**
Click on the map to select your location, or type your city name in the search box. The installer uses this to set your time zone and regional settings. Verify the displayed time is correct. Click "Continue" to proceed.

**User Account Creation:**
Enter your name, choose a username (lowercase, no spaces), and create a strong password. Your username will be used for login and is also your home directory name. The installer includes a password strength indicator to help you create a secure password. Choose whether to require your password for login or log in automatically. For security, we recommend requiring a password, especially on shared computers or laptops. You can also choose to encrypt your home folder for additional security, though this has a small performance impact. Click "Continue" to begin the installation.

**Installation Progress:**
The installer now copies files, installs software packages, and configures your system. You'll see a progress bar and descriptions of what's happening. This process typically takes fifteen to forty-five minutes depending on your hardware speed, installation media type (USB 3.0 is much faster than DVD), and edition selected. The installer shows you slides introducing WilderedOS features while you wait. On slower systems, be patient, the process may occasionally appear to pause but is still working.

**Installation Complete:**
When installation finishes, you'll see a completion message. You can choose to continue testing the live environment or restart your computer to boot into your newly installed WilderedOS system. Remove the installation USB drive or DVD before restarting. Your computer will boot into WilderedOS and present the login screen showing your username.

---

## Post-Installation Setup

After your first boot into WilderedOS, a few additional configuration steps ensure your system is fully set up and optimized.

**First Login and Welcome Wizard:**
Log in with the username and password you created during installation. WilderedOS presents a welcome wizard that helps configure remaining settings. The wizard guides you through connecting online accounts if desired, setting up the sidebar companion preferences, choosing your preferred theme (light or dark mode), and reviewing privacy settings.

**Installing System Updates:**
After completing the welcome wizard, check for system updates immediately. Updates include security patches, bug fixes, and performance improvements released since your ISO was created. Open the update manager from the application menu or system tray. Click "Check for Updates" and install any available updates. This process requires an internet connection and may take several minutes to an hour depending on how many updates are available. Restart your system if prompted after updates complete.

**Installing Additional Drivers:**
WilderedOS includes open-source drivers for most hardware, but certain devices work better with proprietary drivers. Open the "Additional Drivers" utility from the system settings. The tool automatically detects hardware that might benefit from proprietary drivers, particularly NVIDIA graphics cards and certain wireless adapters. Select the recommended drivers and click "Apply Changes." This requires an internet connection and may require a restart.

**Configuring the Sidebar Companion:**
If you installed an edition with the sidebar companion, take a moment to configure its behavior. Access sidebar settings by clicking its icon in the system tray or application menu. You can choose which widgets appear, set the sidebar to auto-hide or remain visible, configure Smart Storage behavior, and adjust how often the sidebar checks for archived applications. On lower-end systems, consider reducing the number of active widgets or setting the sidebar to launch only when needed rather than starting automatically.

**Setting Up Smart Storage:**
The Smart Storage feature automatically organizes your applications and can archive unused ones to save space. Access Smart Storage settings through the file manager or sidebar companion. Review the automatic categorization rules and adjust them if needed. Set the threshold for application archiving, the default is applications unused for thirty days, but you can adjust this higher or lower based on your storage capacity and usage patterns. Enable or disable the feature entirely based on your preferences.

**Installing Additional Software:**
WilderedOS includes a software center where you can browse and install thousands of additional applications. Open the Software Center from the application menu to explore available software organized by category. For low-end devices, prioritize lightweight alternatives. For example, choose lightweight browsers like Midori or Falkon instead of Chrome or Firefox if performance is a concern.

---

## Optimizing for Low-End Devices

If you're running WilderedOS on older or limited hardware, these optimization steps significantly improve performance and responsiveness.

**Adjusting Visual Effects:**
The liquid glass UI effects are beautiful but can strain older graphics hardware. Open system settings and navigate to "Appearance" or "Desktop Effects." You'll find options to disable specific effects such as window animations, transparency, blur effects, and shadow rendering. Start by disabling transparency and blur effects, which have the largest performance impact. If performance still struggles, progressively disable other effects until you find an acceptable balance between appearance and responsiveness.

**Managing Startup Applications:**
Reducing the number of programs that launch automatically at startup speeds up boot time and frees memory. Open "Startup Applications" from system settings to see a list of programs configured to start a
