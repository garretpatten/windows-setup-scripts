#Requires -Version 7
$ErrorActionPreference = 'Continue'
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { exit 0 }
try {
    Start-Service com.docker.service -ErrorAction SilentlyContinue
} catch {
    Write-Warning "Docker service start skipped: $_"
}
