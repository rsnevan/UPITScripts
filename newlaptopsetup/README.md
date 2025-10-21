# 🖥️ GKIT New Laptop Setup

> **An rsnevan product**  
> Automated Windows 11 laptop configuration for University of Pretoria Groenkloof students

---

## ✨ Features

This automated setup solution transforms a fresh Windows 11 laptop from OOBE to fully configured in minutes:

- ✅ **Automated OOBE Bypass** - Skips all Windows setup screens
- ✅ **Local Admin Account** - Creates `user` account with no password
- ✅ **WiFi Configuration** - Connects to TUKS and eduroam networks (WPA2-Enterprise PEAP/MSCHAPv2)
- ✅ **Google Chrome** - Silent installation
- ✅ **Microsoft 365 Education** - Installs Office apps (Word, Excel, PowerPoint, etc.)
- ✅ **Windows Update Control** - Disabled during setup, re-enabled after completion

---

## 📋 Prerequisites

- Fresh Windows 11 laptop (not yet configured, still in OOBE)
- USB flash drive (minimum 1GB)
- Student TUKS credentials (@up.ac.za)
- Microsoft 365 Apps for Education A3 license

---

## 🚀 Quick Start

### 1. Prepare USB Drive

Create the following structure on your USB drive:

```
USB:\
├── autounattend.xml
└── Scripts\
    └── StudentSetup.ps1
```

### 2. Insert USB Before First Boot

- **IMPORTANT:** Plug in USB drive **before** powering on the laptop
- The USB must be inserted before Windows boots for the first time

### 3. Power On and Wait

- Press the power button
- **Do NOT boot from USB** - let Windows boot normally
- Windows will automatically detect `autounattend.xml` and begin automated setup
- OOBE screens will be skipped automatically
- Computer will create the `user` account and auto-login
- **Time estimate:** 2-5 minutes to desktop

### 4. Desktop Setup (Automated)

Once the desktop loads, the setup wizard launches automatically:

1. **Credential Entry** - Enter student TUKS username (without @up.ac.za) and password
2. **WiFi Configuration** - TUKS and eduroam profiles are created and connected
3. **Chrome Installation** - Google Chrome is downloaded and installed silently
4. **Office Installation** - Microsoft 365 Apps for Education are installed
5. **Completion** - Word opens automatically for student to sign in

**Time estimate:** 10-15 minutes for full setup

---

## 🔧 Technical Details

### Computer Configuration

| Setting | Value |
|---------|-------|
| Computer Name | `GKSTUDENT-PC` |
| Local Admin Account | `user` (no password) |
| Timezone | South Africa Standard Time |

### WiFi Networks

Both networks are configured with:
- **Authentication:** WPA2-Enterprise
- **EAP Type:** PEAP (Protected EAP)
- **Inner Authentication:** MS-CHAPv2
- **Certificate Validation:** ClearPass certificates (pre-configured)
- **Credentials:** Saved for automatic connection

| Network | Username Format |
|---------|-----------------|
| TUKS | `username` (without domain) |
| eduroam | `username@up.ac.za` |

### Installed Software

1. **Google Chrome** - Latest stable version
2. **Microsoft 365 Apps for Education**
   - Word, Excel, PowerPoint
   - OneNote, Access, Publisher
   - Product ID: `O365ProPlusEDURetail`
   - Configured for A3 license activation

---

## 📝 Manual Steps Required

After automated setup completes:

1. **Activate Microsoft Office**
   - Open Microsoft Word
   - Click "Sign In"
   - Enter: `username@up.ac.za`
   - Enter UP password
   - Office 365 A3 license activates automatically

2. **Review Desktop Reminder**
   - A file `SETUP_COMPLETE_READ_ME.txt` is created on desktop
   - Contains setup summary and activation instructions

---

## 🔒 Security Notes

- No passwords are stored in the scripts or USB drive
- Credentials are entered live during setup
- Sensitive data is cleared from memory after use
- WiFi credentials are stored securely in Windows credential manager

---

## 🛠️ Troubleshooting

### USB Not Detected

**Problem:** Windows doesn't read `autounattend.xml`  
**Solution:**
- Ensure file is named exactly `autounattend.xml` (not `.txt`)
- Place in root of USB drive (not in a folder)
- USB must be inserted **before** first boot

### WiFi Not Connecting

**Problem:** WiFi profiles created but not connecting  
**Solution:**
- Manually select TUKS or eduroam from WiFi list
- Verify credentials are correct
- Check if TUKS/eduroam networks are in range

### Office Not Installing

**Problem:** Microsoft 365 installation fails  
**Solution:**
- Ensure internet connection is active
- Check available disk space (minimum 4GB free)
- Manually download Office Deployment Tool and retry

### Laptop Already Set Up

**Problem:** Student already completed OOBE  
**Solution:**
- Run `sysprep /oobe /reboot` as Administrator
- Insert USB and let it reboot
- OOBE will restart and read `autounattend.xml`

---

## 📞 Support

**University of Pretoria Groenkloof IT Helpdesk**  
For assistance, please contact **Nev**

---

## 📄 License

This script is provided as-is for use by University of Pretoria Groenkloof IT Helpdesk.

---

## 🔄 Version History

- **v1.0** - Initial release
  - Automated OOBE bypass
  - WiFi configuration (TUKS & eduroam)
  - Chrome and Office 365 installation
  - Windows Update management

---

**Made by rsnevan**