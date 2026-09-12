#Requires -Version 7
$ErrorActionPreference = 'Continue'
# LocalSend ports (mirrors UFW 53317 allow). Best-effort; may need elevation.
function Ensure-FirewallRule {
    param([string]$Name, [string]$Protocol, [int]$Port)
    try {
        $existing = Get-NetFirewallRule -DisplayName $Name -ErrorAction SilentlyContinue
        if ($existing) { return }
        New-NetFirewallRule -DisplayName $Name -Direction Inbound -Protocol $Protocol `
            -LocalPort $Port -Action Allow -ErrorAction Stop | Out-Null
    } catch {
        Write-Warning "Firewall rule '$Name' skipped (elevation may be required): $_"
    }
}

Ensure-FirewallRule -Name 'LocalSend UDP 53317' -Protocol UDP -Port 53317
Ensure-FirewallRule -Name 'LocalSend TCP 53317' -Protocol TCP -Port 53317
