# 🛠️ GKIT Scripts Collection

> **University of Pretoria Groenkloof IT Helpdesk Automation Tools**  
> *An rsnevan product*

A collection of PowerShell, batch, and automation scripts designed to streamline IT helpdesk operations for the University of Pretoria Groenkloof campus.

---

## 📦 Available Scripts

### 🖥️ [New Laptop Setup](./newlaptopsetup/)
**Automated Windows 11 OOBE configuration for student laptops**

Fully automated setup solution that takes a fresh Windows 11 laptop from out-of-box to configured in minutes.

**Features:**
- ✅ Automated OOBE bypass
- ✅ WiFi configuration (TUKS & eduroam with WPA2-Enterprise)
- ✅ Google Chrome installation
- ✅ Microsoft 365 Education installation
- ✅ Local admin account creation

**Use Case:** Student brings new laptop to helpdesk for first-time setup  
**Time Saved:** ~30 minutes → ~15 minutes  
**Status:** ✅ Production Ready

[View Documentation →](./newlaptopsetup/README.md)

---

### 📡 [One-Click WiFi](./one-click-wifi/)
**Quick WiFi profile configuration for TUKS and eduroam networks**

Simple executable that prompts for credentials and instantly configures both campus WiFi networks with proper WPA2-Enterprise settings.

**Features:**
- ✅ Single-click execution
- ✅ Automatic profile removal (if exists)
- ✅ Proper PEAP/MSCHAPv2 configuration
- ✅ Credential validation
- ✅ Connection testing

**Use Case:** Quick WiFi setup for staff/students on existing devices  
**Time Saved:** ~10 minutes → ~2 minutes  
**Status:** 🚧 In Development

[View Documentation →](./one-click-wifi/README.md)

---

### 📺 [TV Slides](./slides/)
**Simple launcher for helpdesk information displays**

Batch file that opens designated slideshow or media file for display on helpdesk TVs/monitors.

**Features:**
- ✅ One-click launch
- ✅ Configurable file path
- ✅ Auto-fullscreen (if supported)

**Use Case:** Quickly launch helpdesk announcements/information on display screens  
**Time Saved:** Manual file navigation eliminated  
**Status:** ✅ Production Ready

[View Documentation →](./slides/README.md)

---

### 🚀 [Helpdesk Startup](./helpdesk-startup/)
**Automated helpdesk workstation initialization**

Startup script that prepares helpdesk computers for daily operation by establishing network connections and launching required applications.

**Features:**
- ✅ UPLogin network share connection
- ✅ Chrome auto-launch
- ✅ Opens designated video file from desktop
- ✅ Error handling and logging

**Use Case:** Daily helpdesk workstation startup routine  
**Time Saved:** ~5 minutes → ~30 seconds  
**Status:** ✅ Production Ready

[View Documentation →](./helpdesk-startup/README.md)

---

## 🎯 Purpose

These scripts are designed to:

- **Reduce repetitive manual tasks** performed by helpdesk staff
- **Standardize configurations** across student and staff devices
- **Minimize human error** in complex setup processes
- **Improve student/staff experience** with faster service delivery
- **Document processes** for knowledge transfer and training

---

## 🏫 Environment

**Organization:** University of Pretoria - Groenkloof Campus  
**Target Users:** Students, staff, and IT helpdesk personnel  
**Infrastructure:**
- WiFi Networks: TUKS (campus-wide), eduroam (global roaming)
- Authentication: WPA2-Enterprise with PEAP/MSCHAPv2
- Microsoft 365 Education A3 licensing
- Windows 11 endpoints

---

## 🔒 Security Considerations

All scripts in this repository:
- ✅ **Do NOT store passwords** in code or configuration files
- ✅ **Prompt for credentials** at runtime when needed
- ✅ **Clear sensitive data** from memory after use
- ✅ **Use Windows credential manager** for secure storage
- ✅ **Include certificate validation** for enterprise WiFi

**Note:** WiFi certificate thumbprints are included in scripts - these are public certificates and not security-sensitive.

---

## 📖 Usage Guidelines

### For Helpdesk Staff:

1. **Download** the appropriate script for your task
2. **Review** the README in each script's folder
3. **Test** on a non-production device first (recommended)
4. **Deploy** according to documentation

### For Developers:

1. **Clone** this repository
2. **Create a branch** for new scripts or modifications
3. **Test thoroughly** before committing
4. **Document** all changes in script README files
5. **Submit pull request** for review

---

## 🛠️ Requirements

### System Requirements:
- **Operating System:** Windows 10/11
- **PowerShell:** Version 5.1 or higher
- **Execution Policy:** RemoteSigned or Unrestricted (for PowerShell scripts)
- **Administrator Rights:** Required for most scripts

### Network Requirements:
- Access to University of Pretoria network resources
- Internet connectivity (for software downloads)
- Valid UP credentials (@up.ac.za)

---

## 📝 Script Standards

All scripts in this repository follow these standards:

- ✅ **Descriptive comments** explaining functionality
- ✅ **Error handling** with user-friendly messages
- ✅ **Logging capability** where appropriate
- ✅ **Credential safety** (no hardcoded passwords)
- ✅ **Cleanup operations** (temp files, sensitive data)
- ✅ **Version information** in file headers
- ✅ **Usage documentation** in README files

---

## 📞 Support

**University of Pretoria Groenkloof IT Helpdesk**  
For assistance or inquiries, please contact the lead developer through their GitHub Profile.

---

## 📄 License

These scripts are provided as-is for use by University of Pretoria Groenkloof IT Helpdesk. 

**Usage Terms:**
- ✅ Free to use within University of Pretoria
- ✅ Free to modify for organizational needs
- ⚠️ No warranty provided
- ⚠️ Use at your own risk

---

## 🎓 About

This collection is maintained by the University of Pretoria Groenkloof IT Helpdesk team to support efficient campus IT operations.

**Lead Developer:** Nevan Rahman
**Organization:** University of Pretoria - Groenkloof Campus  
**Purpose:** IT Helpdesk Automation & Efficiency

---

## 🔄 Repository Structure

```
UPITScripts/
├── README.md (this file)
├── new-laptop-setup/
│   ├── README.md
│   ├── autounattend.xml
│   └── Scripts/
│       └── StudentSetup.ps1
├── one-click-wifi/
│   ├── README.md
│   └── WiFiSetup.ps1
├── tv-slides/
│   ├── README.md
│   └── LaunchSlides.bat
└── helpdesk-startup/
    ├── README.md
    └── HelpdeskStartup.bat
```

---

**Made by rsnevan for UP Groenkloof IT Helpdesk**