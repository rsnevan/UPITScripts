# GKIT New Laptop Setup - An rsnevan product
# This script runs automatically after OOBE completes and desktop loads
# Place this file in X:\Scripts\StudentSetup.ps1 on the USB drive

# Wait for desktop to fully load
Start-Sleep -Seconds 10

# Show setup window
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationFramework

# Create credential input form
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

# Show welcome message
[System.Windows.MessageBox]::Show(
    "Welcome to GKIT New Laptop Setup!`n`nThis wizard will:`n`n• Connect to TUKS and eduroam WiFi`n• Install Google Chrome`n• Install Microsoft 365 Apps for Education`n`nPlease have your student credentials ready.",
    "GKIT New Laptop Setup",
    "OK",
    "Information"
)

# Get student credentials
$TUKSUsername = [Microsoft.VisualBasic.Interaction]::InputBox("Enter TUKS Username (without @up.ac.za):`n`nExample: u12345678", "GKIT Setup - Username", "")

if ([string]::IsNullOrWhiteSpace($TUKSUsername)) {
    [System.Windows.MessageBox]::Show("Setup cancelled. Please run this script again from the desktop shortcut.", "Setup Cancelled", "OK", "Warning")
    exit
}

# Get password using secure prompt
$FormPassword = New-Object System.Windows.Forms.Form
$FormPassword.Text = "GKIT Setup - Password"
$FormPassword.Size = New-Object System.Drawing.Size(400, 150)
$FormPassword.StartPosition = "CenterScreen"
$FormPassword.FormBorderStyle = "FixedDialog"
$FormPassword.MaximizeBox = $false

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
    [System.Windows.MessageBox]::Show("Setup cancelled. Please run this script again from the desktop shortcut.", "Setup Cancelled", "OK", "Warning")
    exit
}

$StudentPasswordPlain = $TextBoxPassword.Text
$FormPassword.Dispose()

if ([string]::IsNullOrWhiteSpace($StudentPasswordPlain)) {
    [System.Windows.MessageBox]::Show("Password cannot be empty. Please run setup again.", "Setup Error", "OK", "Error")
    exit
}

# Construct email addresses
$StudentEmail = "$TUKSUsername@up.ac.za"
$EduroamUsername = "$TUKSUsername@up.ac.za"

# Show progress form
$FormProgress = New-Object System.Windows.Forms.Form
$FormProgress.Text = "GKIT New Laptop Setup - In Progress"
$FormProgress.Size = New-Object System.Drawing.Size(500, 400)
$FormProgress.StartPosition = "CenterScreen"
$FormProgress.FormBorderStyle = "FixedDialog"
$FormProgress.MaximizeBox = $false
$FormProgress.ControlBox = $false

$LabelProgress = New-Object System.Windows.Forms.Label
$LabelProgress.Location = New-Object System.Drawing.Point(10, 10)
$LabelProgress.Size = New-Object System.Drawing.Size(470, 30)
$LabelProgress.Text = "Setting up your laptop... Please wait."
$LabelProgress.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$FormProgress.Controls.Add($LabelProgress)

$TextBoxLog = New-Object System.Windows.Forms.TextBox
$TextBoxLog.Location = New-Object System.Drawing.Point(10, 50)
$TextBoxLog.Size = New-Object System.Drawing.Size(470, 300)
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

# Step 1: Connect to TUKS WiFi
Write-Log "[1/4] Configuring TUKS WiFi..."

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
    
    Write-Log "    ✓ TUKS WiFi profile created"
} catch {
    Write-Log "    ✗ Error creating TUKS profile: $_"
}

# Step 2: Connect to eduroam WiFi
Write-Log "[2/4] Configuring eduroam WiFi..."

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
    
    Write-Log "    ✓ eduroam WiFi profile created"
} catch {
    Write-Log "    ✗ Error creating eduroam profile: $_"
}

# Connect to available network
Write-Log "    Connecting to available WiFi network..."
Start-Sleep -Seconds 2

try {
    netsh wlan connect name="TUKS" 2>&1 | Out-Null
    Start-Sleep -Seconds 5
    
    $connected = netsh wlan show interfaces | Select-String "TUKS|eduroam"
    if (-not $connected) {
        netsh wlan connect name="eduroam" 2>&1 | Out-Null
        Start-Sleep -Seconds 5
    }
    
    Write-Log "    ✓ WiFi connected"
} catch {
    Write-Log "    ⚠ WiFi profiles created, connection may require manual selection"
}

# Step 3: Install Google Chrome
Write-Log "[3/4] Installing Google Chrome..."

try {
    $ChromeInstaller = "$env:TEMP\ChromeSetup.exe"
    $ChromeURL = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
    
    Write-Log "    Downloading Chrome..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $ChromeURL -OutFile $ChromeInstaller -UseBasicParsing
    
    Write-Log "    Installing Chrome..."
    Start-Process -FilePath $ChromeInstaller -ArgumentList "/silent /install" -Wait
    
    Write-Log "    ✓ Chrome installed successfully"
    Remove-Item $ChromeInstaller -Force -ErrorAction SilentlyContinue
} catch {
    Write-Log "    ✗ Error installing Chrome: $_"
}

# Step 4: Install Microsoft 365 Apps for Education
Write-Log "[4/4] Installing Microsoft 365 Apps for Education..."
Write-Log "    This may take 10-15 minutes, please be patient..."

try {
    $ODTPath = "C:\ODT"
    $ODTInstaller = "$env:TEMP\officedeploymenttool.exe"
    New-Item -ItemType Directory -Path $ODTPath -Force | Out-Null
    
    Write-Log "    Downloading Office Deployment Tool..."
    $ODTURL = "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_17328-20162.exe"
    Invoke-WebRequest -Uri $ODTURL -OutFile $ODTInstaller -UseBasicParsing
    
    Write-Log "    Extracting Office Deployment Tool..."
    Start-Process -FilePath $ODTInstaller -ArgumentList "/quiet /extract:$ODTPath" -Wait
    
    # Create configuration XML for Microsoft 365 Education A3
    $ConfigXML = @"
<Configuration>
  <Add OfficeClientEdition="64" Channel="Current">
    <Product ID="O365ProPlusEDURetail">
      <Language ID="en-us" />
      <ExcludeApp ID="Groove" />
      <ExcludeApp ID="Lync" />
    </Product>
  </Add>
  <Display Level="None" AcceptEULA="TRUE" />
  <Property Name="AUTOACTIVATE" Value="1" />
  <Property Name="SharedComputerLicensing" Value="0" />
  <Property Name="PinIconsToTaskbar" Value="TRUE" />
</Configuration>
"@
    
    $ConfigPath = "$ODTPath\configuration.xml"
    $ConfigXML | Out-File -FilePath $ConfigPath -Encoding utf8
    
    Write-Log "    Installing Microsoft 365 (this will take several minutes)..."
    Start-Process -FilePath "$ODTPath\setup.exe" -ArgumentList "/configure `"$ConfigPath`"" -Wait
    
    Write-Log "    ✓ Microsoft 365 installed successfully"
    
    # Clean up
    Remove-Item $ODTInstaller -Force -ErrorAction SilentlyContinue
    Remove-Item $ODTPath -Recurse -Force -ErrorAction SilentlyContinue
    
} catch {
    Write-Log "    ✗ Error installing Microsoft 365: $_"
}

# Re-enable Windows Update
Write-Log ""
Write-Log "Re-enabling Windows Update..."
try {
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -ErrorAction SilentlyContinue
    Set-Service wuauserv -StartupType Manual -ErrorAction SilentlyContinue
    Start-Service wuauserv -ErrorAction SilentlyContinue
    Write-Log "✓ Windows Update re-enabled"
} catch {
    Write-Log "⚠ Windows Update will resume automatically"
}

Write-Log ""
Write-Log "============================================"
Write-Log "Setup Complete!"
Write-Log "============================================"

# Clear sensitive data
$StudentPasswordPlain = $null
$TUKSCred = $null
$EduroamCred = $null
[System.GC]::Collect()

# Create desktop reminder
$ReminderText = @"
GKIT NEW LAPTOP SETUP - COMPLETE
An rsnevan product

Your laptop has been configured with:
✓ Local admin account: user (no password)
✓ Computer name: GKSTUDENT-PC
✓ WiFi networks: TUKS and eduroam configured
✓ Google Chrome installed
✓ Microsoft 365 Apps for Education installed

NEXT STEP - Activate Microsoft Office:
1. Open Microsoft Word
2. Click 'Sign In'
3. Enter your UP credentials:
   Email: $StudentEmail
   Password: [Your UP password]
4. Your Microsoft 365 A3 license will activate automatically

Your WiFi credentials are saved for both TUKS and eduroam networks.

University of Pretoria Groenkloof IT Helpdesk
For assistance, please contact Nev.
"@

$ReminderPath = "$env:PUBLIC\Desktop\SETUP_COMPLETE_READ_ME.txt"
$ReminderText | Out-File -FilePath $ReminderPath -Encoding utf8

Start-Sleep -Seconds 3
$FormProgress.Close()

# Show completion message
[System.Windows.MessageBox]::Show(
    "Setup Complete!`n`nYour laptop is ready to use.`n`nNEXT STEP:`n• Open Microsoft Word`n• Sign in with: $StudentEmail`n• Your Office 365 A3 license will activate automatically`n`nA reminder file has been saved to your desktop.",
    "GKIT New Laptop Setup - Complete",
    "OK",
    "Information"
)

# Open Word for activation
$WordPath = "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"
if (Test-Path $WordPath) {
    Start-Process $WordPath
}

# Delete this script
Start-Sleep -Seconds 2
Remove-Item $PSCommandPath -Force -ErrorAction SilentlyContinue