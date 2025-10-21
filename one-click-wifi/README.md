# 📡 One-Click WiFi

> **An rsnevan product**  
> Quick WiFi configuration for University of Pretoria campus networks

---

## ✨ Features

A simple, user-friendly tool that configures both TUKS and eduroam WiFi networks in seconds.

- ✅ **One-click execution** - Just run and enter credentials
- ✅ **Automatic profile cleanup** - Removes old/corrupted profiles
- ✅ **Dual network setup** - Configures both TUKS and eduroam
- ✅ **Proper enterprise authentication** - WPA2-Enterprise PEAP/MSCHAPv2
- ✅ **Secure credential storage** - Uses Windows credential manager
- ✅ **Auto-connection** - Connects to available network automatically

---

## 🎯 Use Cases

Perfect for:
- 📱 Quick WiFi setup on staff/student devices
- 🔧 Fixing broken WiFi profiles
- 🔄 Updating WiFi credentials after password changes
- 💻 Setting up new devices without full OOBE automation
- 🆘 Helpdesk quick-fix for WiFi connection issues

---

## 📋 Prerequisites

- Windows 10/11 device
- PowerShell 5.1 or higher
- Administrator privileges
- Valid TUKS credentials (@up.ac.za)
- Within range of TUKS or eduroam network (for connection testing)

---

## 🚀 Quick Start

### Option 1: Direct Execution

1. **Right-click** `OneClickWiFi.ps1`
2. Select **"Run with PowerShell"**
3. Click **"Yes"** when prompted for Administrator access
4. Follow the on-screen prompts

### Option 2: From PowerShell (Administrator)

```powershell
# Navigate to script directory
cd C:\Path\To\Script

# Run the script
.\OneClickWiFi.ps1
```

### Option 3: Create Desktop Shortcut

Create a shortcut with this target:
```
powershell.exe -ExecutionPolicy Bypass -File "C:\Path\To\OneClickWiFi.ps1"
```
Right-click shortcut → Properties → Advanced → **Check "Run as administrator"**

---

## 📖 How It Works

### Step 1: Remove Existing Profiles
- Searches for existing TUKS and eduroam profiles
- Removes them to ensure clean configuration
- Prevents conflicts with old/corrupted settings

### Step 2: Create TUKS Profile
- Creates WPA2-Enterprise profile
- Configures PEAP/MSCHAPv2 authentication
- Includes ClearPass certificate validation
- Stores credentials securely

### Step 3: Create eduroam Profile
- Creates WPA2-Enterprise profile (global roaming)
- Configures PEAP/MSCHAPv2 authentication
- Uses `username@up.ac.za` format for eduroam
- Enables fast reconnection

### Step 4: Connect
- Attempts to connect to TUKS
- Falls back to eduroam if TUKS unavailable
- Reports connection status

---

## 🔧 Technical Details

### WiFi Configuration

| Setting | Value |
|---------|-------|
| Networks | TUKS, eduroam |
| Authentication | WPA2-Enterprise |
| EAP Type | PEAP (Type 25) |
| Inner Auth | MS-CHAPv2 (Type 26) |
| Certificates | ClearPass trusted roots |
| PMK Caching | Enabled (720 min TTL) |

### Username Formats

| Network | Username Format | Example |
|---------|----------------|---------|
| TUKS | `username` | `u12345678` |
| eduroam | `username@up.ac.za` | `u12345678@up.ac.za` |

---

## 💡 Usage Tips

### For Helpdesk Staff:

1. **Keep script on network share** for easy access
2. **Use when:** Student reports WiFi connection issues
3. **Time saved:** ~10 minutes → ~2 minutes
4. **Alternative to:** Manual WiFi configuration via Settings

### For Students/Staff:

1. **Run after password change** to update stored credentials
2. **Use on multiple devices** with same credentials
3. **Bookmark location** for future use
4. **No installation needed** - just run when required

---

## 🛠️ Troubleshooting

### Script Won't Run

**Problem:** "Execution Policy" error  
**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Not Running as Administrator

**Problem:** "Administrator privileges required" warning  
**Solution:**
- Right-click PowerShell → "Run as administrator"
- Navigate to script and run
- OR right-click script → "Run as administrator"

### Profile Created But Not Connecting

**Problem:** WiFi profiles created successfully but not connecting  
**Solution:**
- Verify credentials are correct
- Check if TUKS/eduroam networks are in range
- Manually select network from WiFi list
- Restart WiFi adapter (Settings → Network → WiFi → Turn off/on)

### "Interface not found" Error

**Problem:** Script can't detect WiFi adapter  
**Solution:**
- Ensure WiFi adapter is enabled
- Check Device Manager for driver issues
- Try disabling/re-enabling WiFi adapter
- Run: `netsh wlan show interfaces` to verify adapter

### Credentials Not Saved

**Problem:** Prompted for credentials every time  
**Solution:**
- Re-run script with correct credentials
- Ensure "Remember my credentials" equivalent is working
- Check Windows Credential Manager for stored credentials

---

## 🔒 Security Notes

- ✅ **No hardcoded passwords** - Credentials entered at runtime
- ✅ **Secure storage** - Uses Windows Credential Manager
- ✅ **Certificate validation** - ClearPass certificates included
- ✅ **Memory cleanup** - Sensitive data cleared after use
- ✅ **No logging** - Credentials never written to disk

---

## 📞 Support

**University of Pretoria Groenkloof IT Helpdesk**  
For assistance, please contact the lead developer through this GitHub Profile.

---

## 🔄 Version History

- **v1.0** - Initial release
  - TUKS and eduroam configuration
  - Profile removal and recreation
  - Automatic connection attempt
  - Administrator privilege check

---

## 📄 License

This script is provided as-is for use by University of Pretoria.

---

**Made by rsnevan**