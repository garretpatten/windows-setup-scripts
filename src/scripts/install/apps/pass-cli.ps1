#Requires -Version 7
$ErrorActionPreference = 'Continue'
if (Get-Command pass-cli -ErrorAction SilentlyContinue) { exit 0 }

$arch = if ([Environment]::Is64BitOperatingSystem) { 'x86_64' } else { 'i686' }
# pass-cli Windows builds use windows-x86_64 naming when published.
$url = "https://github.com/protonpass/pass-cli/releases/latest/download/pass-cli-windows-${arch}.exe"
$destDir = Join-Path $env:LOCALAPPDATA 'pass-cli'
$dest = Join-Path $destDir 'pass-cli.exe'
New-Item -ItemType Directory -Force -Path $destDir | Out-Null

try {
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
    if ((Test-Path $dest) -and ((Get-Item $dest).Length -gt 0)) {
        $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
        if ($userPath -notlike "*$destDir*") {
            [Environment]::SetEnvironmentVariable('Path', "$userPath;$destDir", 'User')
            $env:Path = "$env:Path;$destDir"
        }
        Write-Host "[INFO] Installed pass-cli -> $dest"
    }
} catch {
    Write-Warning "pass-cli install failed (continuing): $_"
}
