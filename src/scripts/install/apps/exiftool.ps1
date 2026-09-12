#Requires -Version 7
$ErrorActionPreference = 'Continue'
if (Get-Command exiftool -ErrorAction SilentlyContinue) { exit 0 }

# PhilHarvey.ExifTool was removed from winget; install the official Windows
# build from SourceForge, using the version published at exiftool.org/ver.txt.
$destDir = Join-Path $env:LOCALAPPDATA 'Programs\exiftool'
if (Test-Path -LiteralPath (Join-Path $destDir 'exiftool.exe')) { exit 0 }

try {
    $ver = (Invoke-WebRequest -Uri 'https://exiftool.org/ver.txt' -UseBasicParsing).Content.Trim()
    if ($ver -notmatch '^\d+(\.\d+)*$') { throw "unexpected ver.txt content: $ver" }
    $zipPath = Join-Path $env:TEMP ("exiftool-${ver}_64.zip")
    $zipUrl = "https://sourceforge.net/projects/exiftool/files/exiftool-${ver}_64.zip/download"
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing
    $stage = Join-Path $env:TEMP ("exiftool-${ver}-extract")
    if (Test-Path -LiteralPath $stage) { Remove-Item -LiteralPath $stage -Recurse -Force }
    Expand-Archive -LiteralPath $zipPath -DestinationPath $stage -Force
    # The zip wraps everything in a versioned folder that must stay intact:
    # exiftool.exe resolves exiftool_files\ relative to its own directory.
    $appDir = Get-ChildItem -LiteralPath $stage -Directory | Select-Object -First 1
    if (-not $appDir) { throw 'exiftool zip did not contain the expected folder' }
    if (Test-Path -LiteralPath $destDir) { Remove-Item -LiteralPath $destDir -Recurse -Force }
    Move-Item -LiteralPath $appDir.FullName -Destination $destDir
    # Keep the pause-on-exit variant and add a plain exiftool.exe alias.
    $kExe = Join-Path $destDir 'exiftool(-k).exe'
    if (Test-Path -LiteralPath $kExe) {
        Copy-Item -LiteralPath $kExe -Destination (Join-Path $destDir 'exiftool.exe') -Force
    }
    Remove-Item -LiteralPath $stage -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $zipPath -Force -ErrorAction SilentlyContinue
    if (Test-Path -LiteralPath (Join-Path $destDir 'exiftool.exe')) {
        $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
        if ($userPath -notlike "*$destDir*") {
            [Environment]::SetEnvironmentVariable('Path', "$userPath;$destDir", 'User')
        }
        $env:Path = "$env:Path;$destDir"
        Write-Host "[INFO] Installed exiftool $ver -> $destDir"
    } else {
        Write-Warning 'exiftool.exe missing after extract (continuing)'
    }
} catch {
    Write-Warning "exiftool install failed (continuing): $_"
}
