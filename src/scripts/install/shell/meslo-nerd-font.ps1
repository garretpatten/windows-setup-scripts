#Requires -Version 7
$ErrorActionPreference = 'Continue'
$fontsDir = Join-Path $env:LOCALAPPDATA 'Microsoft/Windows/Fonts'
$marker = Join-Path $fontsDir 'MesloLGMNerdFont-Regular.ttf'
if (Test-Path -LiteralPath $marker) { exit 0 }

$temp = Join-Path $env:TEMP_DIR 'meslo-font'
New-Item -ItemType Directory -Force -Path $temp, $fontsDir | Out-Null
$zip = Join-Path $temp 'Meslo.zip'
try {
    Invoke-WebRequest -Uri 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Meslo.zip' `
        -OutFile $zip -UseBasicParsing
    Expand-Archive -LiteralPath $zip -DestinationPath $temp -Force
    Get-ChildItem -Path $temp -Include *.ttf, *.otf -Recurse | ForEach-Object {
        $dest = Join-Path $fontsDir $_.Name
        Copy-Item $_.FullName $dest -Force
        try {
            New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' `
                -Name $_.Name -Value $dest -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
        } catch {}
    }
} catch {
    Write-Warning "Meslo Nerd Font install failed: $_"
}
