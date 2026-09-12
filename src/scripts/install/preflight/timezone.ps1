#Requires -Version 7
$ErrorActionPreference = 'Continue'
try {
    $tz = (Get-TimeZone).Id
    if ($tz -eq 'UTC') {
        Set-TimeZone -Id 'Eastern Standard Time' -ErrorAction SilentlyContinue
    }
} catch {
    Write-Warning "Timezone set skipped: $_"
}
