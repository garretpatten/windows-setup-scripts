# 1Password
winget install -e --id AgileBits.1Password

# Burp Suite
winget install -e --id PortSwigger.BurpSuite.Community --source winget

# OWASP ZAP
winget install -e --id ZAP.ZAP --source winget

# Windows firewall
Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True

# OWASP ZAP
winget install -e --id ZAP.ZAP --source winget

# Proton VPN
winget install -e --id ProtonTechnologies.ProtonVPN

### Windows Defender ###

# Enable Real-Time Monitoring
Set-MpPreference -DisableRealtimeMonitoring $false
# Enable network protection (against network-based threats)
Set-MpPreference -EnableNetworkProtection AuditMode
# Set scan type to Full (can be Quick or Full)
Set-MpPreference -ScanType 2
# Set daily scan schedule at 2 AM
Set-MpPreference -RemediationScheduleDay Everyday -RemediationScheduleTime 02:00
# Enable IOAV protection (protects against file downloads and attachments in emails)
Set-MpPreference -DisableIOAVProtection $false
# Enable behavior monitoring
Set-MpPreference -DisableBehaviorMonitoring $false
# Enable scanning of scripts
Set-MpPreference -DisableScriptScanning $false
# Enable scanning of removable drives during full scan
Set-MpPreference -DisableRemovableDriveScanning $false

# Windows firewall
Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True
