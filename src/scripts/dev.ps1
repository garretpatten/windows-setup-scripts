# Postman
winget install -e --id Postman.Postman --source winget

# Install Oracle VirtualBox
winget install -e --id=Oracle.VirtualBox --source winget

# VS Code
function Is-VSCodeInstalled {
    $vscodePaths = @(
        "${env:ProgramFiles}\Microsoft VS Code\Code.exe",
        "${env:ProgramFiles(x86)}\Microsoft VS Code\Code.exe",
        "${env:LocalAppData}\Programs\Microsoft VS Code\Code.exe"
    )

    foreach ($path in $vscodePaths) {
        if (Test-Path $path) {
            return $true
        }
    }

    return $false
}

if (Is-VSCodeInstalled) {
    Write-Host "VS Code is already installed."
} else {
    winget install --id Microsoft.VisualStudioCode -e --source winget
    Copy-Item ..\config-files\vs-code\settings.json $env:USERPROFILE\AppData\Roaming\Code\User\settings.json
}
