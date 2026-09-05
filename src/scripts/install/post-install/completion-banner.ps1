#Requires -Version 7
$art = Join-Path $env:PROJECT_ROOT 'src/assets/windows.txt'
if (Test-Path -LiteralPath $art) {
    Write-Host ''
    Write-Host ('=' * 76)
    Get-Content -LiteralPath $art | Write-Host
    Write-Host ('=' * 76)
    Write-Host ''
}
Write-Host 'Setup completed.'
