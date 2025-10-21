# One-Click WiFi - An rsnevan product
# Quick WiFi configuration for TUKS and eduroam networks
# University of Pretoria Groenkloof IT Helpdesk

# Require Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script requires Administrator privileges. Please run as Administrator."
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationFramework

# Welcome message
$welcome = [System.Windows.MessageBox]::Show(
    "One-Click WiFi Setup`n`nThis will configure TUKS and eduroam WiFi on your device.`n`nAny existing profiles will be removed and recreated.`n`nContinue?",
    "One-Click WiFi - GKIT",
    "YesNo",
    "Question"
)

if ($welcome -eq "No") {
    exit
}

# Get TUKS username
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$TUKSUsername = [Microsoft.VisualBasic.Interaction]::InputBox("Enter your TUKS Username (without @up.ac.za):`n`nExample: u12345678", "One-Click WiFi - Username", "")

if ([string]::IsNullOrWhiteSpace($TUKSUsername)) {
    [System.Windows.MessageBox]::Show("Setup cancelled. Username is required.", "Cancelled", "OK", "Warning")
    exit
}

# Get password
$FormPassword = New-Object System.Windows.Forms.Form
$FormPassword.Text = "One-Click WiFi - Password"
$FormPassword.Size = New-Object System.Drawing.Size(400, 150)
$FormPassword.StartPosition = "CenterScreen"
$FormPassword.FormBorderStyle = "FixedDialog"
$FormPassword.MaximizeBox = $false
$FormPassword.MinimizeBox = $false

$LabelPassword = New-Object System.Windows.Forms.Label
$LabelPassword.Location = New-Object System.Drawing.Point(10, 20)
$LabelPassword.Size = New-Object System.Drawing.Size(370, 20)
$LabelPassword.Text = "Enter your UP password:"
$FormPassword.Controls.Add($LabelPassword)

$TextBoxPassword = New-Object System.Windows.Forms.TextBox
$TextBoxPassword.Location = New-Object System.Drawing.Point(10, 50)
$TextBoxPassword.Size = New-Object System.Drawing.Size(360, 20)
$TextBoxPassword.PasswordChar = '*'
$FormPassword.Controls.Add($TextBoxPassword)

$ButtonOK = New-Object System.Windows.Forms.Button
$ButtonOK.Location = New-Object System.Drawing.Point(220, 80)
$ButtonOK.Size = New-Object System.Drawing.Size(75, 23)
$ButtonOK.Text = "OK"
$ButtonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
$FormPassword.AcceptButton = $ButtonOK
$FormPassword.Controls.Add($ButtonOK)

$ButtonCancel = New-Object System.Windows.Forms.Button
$ButtonCancel.Location = New-Object System.Drawing.Point(300, 80)
$ButtonCancel.Size = New-Object System.Drawing.Size(75, 23)
$ButtonCancel.Text = "Cancel"
$ButtonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$FormPassword.Controls.Add($ButtonCancel)

$result = $FormPassword.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::Cancel) {
    [System.Windows.MessageBox]::Show("Setup cancelled.", "Cancelled", "OK", "Warning")
    exit
}

$StudentPasswordPlain = $TextBoxPassword.Text
$FormPassword.Dispose()

if ([string]::IsNullOrWhiteSpace($StudentPasswordPlain)) {
    [System.Windows.MessageBox]::Show("Password cannot be empty.", "Error", "OK", "Error")
    exit
}

# Construct credentials
$StudentEmail = "$TUKSUsername@up.ac.za"
$EduroamUsername = "$TUKSUsername@up.ac.za"

# Create progress window
$FormProgress = New-Object System.Windows.Forms.Form
$FormProgress.Text = "One-Click WiFi - Configuring..."
$FormProgress.Size = New-Object System.Drawing.Size(500, 350)
$FormProgress.StartPosition = "CenterScreen"
$FormProgress.FormBorderStyle = "FixedDialog"
$FormProgress.MaximizeBox = $false
$FormProgress.MinimizeBox = $false
$FormProgress.ControlBox = $false

$LabelProgress = New-Object System.Windows.Forms.Label
$LabelProgress.Location = New-Object System.Drawing.Point(10, 10)
$LabelProgress.Size = New-Object System.Drawing.Size(470, 30)
$LabelProgress.Text = "Configuring WiFi networks..."
$LabelProgress.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$FormProgress.Controls.Add($LabelProgress)

$TextBoxLog = New-Object System.Windows.Forms.TextBox
$TextBoxLog.Location = New-Object System.Drawing.Point(10, 50)
$TextBoxLog.Size = New-Object System.Drawing.Size(470, 250)
$TextBoxLog.Multiline = $true
$TextBoxLog.ScrollBars = "Vertical"
$TextBoxLog.ReadOnly = $true
$TextBoxLog.Font = New-Object System.Drawing.Font("Consolas", 9)
$FormProgress.Controls.Add($TextBoxLog)

$FormProgress.Show()
$FormProgress.Refresh()

function Write-Log {
    param([string]$Message)
    $TextBoxLog.AppendText("$Message`r`n")
    $TextBoxLog.Refresh()
}

Write-Log "One-Click WiFi Configuration"
Write-Log "Username: $TUKSUsername"
Write-Log "Email: $StudentEmail"
Write-Log ""

# Step 1: Remove existing profiles
Write-Log "[1/3] Removing existing WiFi profiles..."

try {
    $existingTUKS = netsh wlan show profiles | Select-String "TUKS"
    if ($existingTUKS) {
        netsh wlan delete profile name="TUKS" 2>&1 | Out-Null
        Write-Log "    ✓ Removed existing TUKS profile"
    } else {
        Write-Log "    ℹ No existing TUKS profile found"
    }
} catch {
    Write-Log "    ⚠ Could not remove TUKS profile: $_"
}

try {
    $existingEduroam = netsh wlan show profiles | Select-String "eduroam"
    if ($existingEduroam) {
        netsh wlan delete profile name="eduroam" 2>&1 | Out-Null
        Write-Log "    ✓ Removed existing eduroam profile"
    } else {
        Write-Log "    ℹ No existing eduroam profile found"
    }
} catch {
    Write-Log "    ⚠ Could not remove eduroam profile: $_"
}

# Step 2: Create TUKS profile
Write-Log ""
Write-Log "[2/3] Creating TUKS WiFi profile..."

try {
    $TUKSProfileXML = @"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <n>TUKS</n>
    <SSIDConfig>
        <SSID>
            <hex>54554B53</hex>
            <n>TUKS</n>
        </SSID>
    </SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>auto</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>WPA2</authentication>
                <encryption>AES</encryption>
                <useOneX>true</useOneX>
            </authEncryption>
            <PMKCacheMode>enabled</PMKCacheMode>
            <PMKCacheTTL>720</PMKCacheTTL>
            <PMKCacheSize>128</PMKCacheSize>
            <preAuthMode>disabled</preAuthMode>
            <OneX xmlns="http://www.microsoft.com/networking/OneX/v1">
                <authMode>user</authMode>
                <EAPConfig><EapHostConfig xmlns="http://www.microsoft.com/provisioning/EapHostConfig"><EapMethod><Type xmlns="http://www.microsoft.com/provisioning/EapCommon">25</Type><VendorId xmlns="http://www.microsoft.com/provisioning/EapCommon">0</VendorId><VendorType xmlns="http://www.microsoft.com/provisioning/EapCommon">0</VendorType><AuthorId xmlns="http://www.microsoft.com/provisioning/EapCommon">0</AuthorId></EapMethod><Config xmlns="http://www.microsoft.com/provisioning/EapHostConfig"><Eap xmlns="http://www.microsoft.com/provisioning/BaseEapConnectionPropertiesV1"><Type>25</Type><EapType xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV1"><ServerValidation><DisableUserPromptForServerValidation>false</DisableUserPromptForServerValidation><ServerNames></ServerNames><TrustedRootCA>f2 86 1b b6 48 c2 aa 73 86 e8 4f cb 38 94 6e a8 23 73 da 29 </TrustedRootCA><TrustedRootCA>db e2 07 79 f3 54 b9 ce 2d bb 5d 56 7a 1c 49 cb a7 2b 0c a1 </TrustedRootCA></ServerValidation><FastReconnect>true</FastReconnect><InnerEapOptional>false</InnerEapOptional><Eap xmlns="http://www.microsoft.com/provisioning/BaseEapConnectionPropertiesV1"><Type>26</Type><EapType xmlns="http://www.microsoft.com/provisioning/MsChapV2ConnectionPropertiesV1"><UseWinLogonCredentials>false</UseWinLogonCredentials></EapType></Eap><EnableQuarantineChecks>false</EnableQuarantineChecks><RequireCryptoBinding>false</RequireCryptoBinding><PeapExtensions><PerformServerValidation xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV2">true</PerformServerValidation><AcceptServerName xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV2">true</AcceptServerName><PeapExtensionsV2 xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV2"><AllowPromptingWhenServerCANotFound xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV3">true</AllowPromptingWhenServerCANotFound></PeapExtensionsV2></PeapExtensions></EapType></Eap></Config></EapHostConfig></EAPConfig>
            </OneX>
        </security>
    </MSM>
    <MacRandomization xmlns="http://www.microsoft.com/networking/WLAN/profile/v3">
        <enableRandomization>false</enableRandomization>
    </MacRandomization>
</WLANProfile>
"@
    
    $TUKSProfilePath = "$env:TEMP\tuks_profile.xml"
    $TUKSProfileXML | Out-File -FilePath $TUKSProfilePath -Encoding utf8
    
    netsh wlan add profile filename="$TUKSProfilePath" user=all 2>&1 | Out-Null
    
    # Set TUKS credentials
    $TUKSCred = @"
<EapHostUserCredentials xmlns="http://www.microsoft.com/provisioning/EapHostUserCredentials">
    <EapMethod>
        <Type xmlns="http://www.microsoft.com/provisioning/EapCommon">25</Type>
    </EapMethod>
    <Credentials xmlns="http://www.microsoft.com/provisioning/MsPeapUserCredentials">
        <PeapUserName>$TUKSUsername</PeapUserName>
        <PeapPassword>$StudentPasswordPlain</PeapPassword>
    </Credentials>
</EapHostUserCredentials>
"@
    
    $interface = (netsh wlan show interfaces | Select-String "Name").ToString().Split(":")[1].Trim()
    netsh wlan set profileparameter name="TUKS" EAPUserData="$TUKSCred" interface="$interface" 2>&1 | Out-Null
    
    Remove-Item $TUKSProfilePath -Force -ErrorAction SilentlyContinue
    
    Write-Log "    ✓ TUKS WiFi profile created successfully"
} catch {
    Write-Log "    ✗ Error creating TUKS profile: $_"
}

# Step 3: Create eduroam profile
Write-Log ""
Write-Log "[3/3] Creating eduroam WiFi profile..."

try {
    $EduroamProfileXML = @"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <n>eduroam</n>
    <SSIDConfig>
        <SSID>
            <hex>656475726F616D</hex>
            <n>eduroam</n>
        </SSID>
    </SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>auto</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>WPA2</authentication>
                <encryption>AES</encryption>
                <useOneX>true</useOneX>
            </authEncryption>
            <PMKCacheMode>enabled</PMKCacheMode>
            <PMKCacheTTL>720</PMKCacheTTL>
            <PMKCacheSize>128</PMKCacheSize>
            <preAuthMode>disabled</preAuthMode>
            <OneX xmlns="http://www.microsoft.com/networking/OneX/v1">
                <authMode>user</authMode>
                <EAPConfig><EapHostConfig xmlns="http://www.microsoft.com/provisioning/EapHostConfig"><EapMethod><Type xmlns="http://www.microsoft.com/provisioning/EapCommon">25</Type><VendorId xmlns="http://www.microsoft.com/provisioning/EapCommon">0</VendorId><VendorType xmlns="http://www.microsoft.com/provisioning/EapCommon">0</VendorType><AuthorId xmlns="http://www.microsoft.com/provisioning/EapCommon">0</AuthorId></EapMethod><Config xmlns="http://www.microsoft.com/provisioning/EapHostConfig"><Eap xmlns="http://www.microsoft.com/provisioning/BaseEapConnectionPropertiesV1"><Type>25</Type><EapType xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV1"><ServerValidation><DisableUserPromptForServerValidation>false</DisableUserPromptForServerValidation><ServerNames></ServerNames><TrustedRootCA>f2 86 1b b6 48 c2 aa 73 86 e8 4f cb 38 94 6e a8 23 73 da 29 </TrustedRootCA><TrustedRootCA>db e2 07 79 f3 54 b9 ce 2d bb 5d 56 7a 1c 49 cb a7 2b 0c a1 </TrustedRootCA></ServerValidation><FastReconnect>true</FastReconnect><InnerEapOptional>false</InnerEapOptional><Eap xmlns="http://www.microsoft.com/provisioning/BaseEapConnectionPropertiesV1"><Type>26</Type><EapType xmlns="http://www.microsoft.com/provisioning/MsChapV2ConnectionPropertiesV1"><UseWinLogonCredentials>false</UseWinLogonCredentials></EapType></Eap><EnableQuarantineChecks>false</EnableQuarantineChecks><RequireCryptoBinding>false</RequireCryptoBinding><PeapExtensions><PerformServerValidation xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV2">true</PerformServerValidation><AcceptServerName xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV2">true</AcceptServerName><PeapExtensionsV2 xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV2"><AllowPromptingWhenServerCANotFound xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV3">true</AllowPromptingWhenServerCANotFound></PeapExtensionsV2></PeapExtensions></EapType></Eap></Config></EapHostConfig></EAPConfig>
            </OneX>
        </security>
    </MSM>
    <MacRandomization xmlns="http://www.microsoft.com/networking/WLAN/profile/v3">
        <enableRandomization>false</enableRandomization>
    </MacRandomization>
</WLANProfile>
"@
    
    $EduroamProfilePath = "$env:TEMP\eduroam_profile.xml"
    $EduroamProfileXML | Out-File -FilePath $EduroamProfilePath -Encoding utf8
    
    netsh wlan add profile filename="$EduroamProfilePath" user=all 2>&1 | Out-Null
    
    # Set eduroam credentials
    $EduroamCred = @"
<EapHostUserCredentials xmlns="http://www.microsoft.com/provisioning/EapHostUserCredentials">
    <EapMethod>
        <Type xmlns="http://www.microsoft.com/provisioning/EapCommon">25</Type>
    </EapMethod>
    <Credentials xmlns="http://www.microsoft.com/provisioning/MsPeapUserCredentials">
        <PeapUserName>$EduroamUsername</PeapUserName>
        <PeapPassword>$StudentPasswordPlain</PeapPassword>
    </Credentials>
</EapHostUserCredentials>
"@
    
    netsh wlan set profileparameter name="eduroam" EAPUserData="$EduroamCred" interface="$interface" 2>&1 | Out-Null
    
    Remove-Item $EduroamProfilePath -Force -ErrorAction SilentlyContinue
    
    Write-Log "    ✓ eduroam WiFi profile created successfully"
} catch {
    Write-Log "    ✗ Error creating eduroam profile: $_"
}

# Try to connect
Write-Log ""
Write-Log "Attempting to connect to available network..."
Start-Sleep -Seconds 2

try {
    # Try TUKS first
    netsh wlan connect name="TUKS" 2>&1 | Out-Null
    Start-Sleep -Seconds 5
    
    $connected = netsh wlan show interfaces | Select-String "TUKS"
    if ($connected) {
        Write-Log "✓ Connected to TUKS"
    } else {
        # Try eduroam
        netsh wlan connect name="eduroam" 2>&1 | Out-Null
        Start-Sleep -Seconds 5
        
        $connected = netsh wlan show interfaces | Select-String "eduroam"
        if ($connected) {
            Write-Log "✓ Connected to eduroam"
        } else {
            Write-Log "⚠ Profiles created but not connected"
            Write-Log "  Please manually select TUKS or eduroam from WiFi list"
        }
    }
} catch {
    Write-Log "⚠ Connection error - please manually select network"
}

Write-Log ""
Write-Log "=========================================="
Write-Log "Configuration Complete!"
Write-Log "=========================================="

# Clear sensitive data
$StudentPasswordPlain = $null
$TUKSCred = $null
$EduroamCred = $null
[System.GC]::Collect()

Start-Sleep -Seconds 3
$FormProgress.Close()

# Show completion
[System.Windows.MessageBox]::Show(
    "WiFi Configuration Complete!`n`nBoth TUKS and eduroam networks are now configured with your credentials.`n`nYour device will automatically connect when in range.`n`nUsername: $TUKSUsername`nEmail: $StudentEmail",
    "One-Click WiFi - Complete",
    "OK",
    "Information"
)