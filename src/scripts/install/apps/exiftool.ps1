#Requires -Version 7
$ErrorActionPreference = 'Continue'
if (Get-Command exiftool -ErrorAction SilentlyContinue) { exit 0 }

# PhilHarvey.ExifTool was removed from winget; install the official Windows
# build from SourceForge, using the version published at exiftool.org/ver.txt.
$destDir = Join-Path $env:LOCALAPPDATA 'Programs\exiftool'
$dest = Join-Path $destDir 'exiftool.exe'
if (Test-Path -LiteralPath $dest) { exit 0 }

try {
    $ver = (Invoke-WebRequest -Uri 'https://exiftool.org/ver.txt' -UseBasicParsing).Content.Trim()
    if (-not $ver -match '^\d+(\.\d+)*$') { throw "unexpected ver.txt content: $ver" }
    $zipPath = Join-Path $env:TEMP ("exiftool-${ver}_64.zip")
    $zipUrl = "https://sourceforge.net/projects/exiftool/files/exiftool-${ver}_64.zip/download"
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing
    Expand-Archive -LiteralPath $zipPath -DestinationPath $destDir -Force
    # The zip ships the exe as "exiftool(-k).exe"; rename for normal CLI use.
    $inner = Join-Path $destDir 'exiftool(-k).exe'
    if (Test-Path -LiteralPath $inner) {
        Move-Item -LiteralPath $inner -Destination $dest -Force
    }
    Remove-Item -LiteralPath $zipPath -Force -ErrorAction SilentlyContinue
    if (Test-Path -LiteralPath $dest) {
        $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
        if ($userPath -notlike "*$destDir*") {
            [Environment]::SetEnvironmentVariable('Path', "$userPath;$destDir", 'User')
            $env:Path = "$env:Path;$destDir"
        }
        Write-Host "[INFO] Installed exiftool $ver -> $dest"
    } else {
        Write-Warning 'exiftool.exe not found after extract (continuing)'
    }
} catch {
    Write-Warning "exiftool install failed (continuing): $_"
}
