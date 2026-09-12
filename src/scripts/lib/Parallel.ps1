#Requires -Version 7

function Start-SetupJobBestEffort {
    param([Parameter(Mandatory)][string]$Script)

    Ensure-TempDir
    $projectRoot = $env:PROJECT_ROOT
    $tempDir = $env:TEMP_DIR

    return Start-Job -ScriptBlock {
        param($Path, $Root, $Temp)
        $env:PROJECT_ROOT = $Root
        $env:TEMP_DIR = $Temp
        $ErrorActionPreference = 'Continue'
        try {
            & $Path
        } catch {
            Write-Warning $_
        }
    } -ArgumentList $Script, $projectRoot, $tempDir
}

function Wait-SetupJobsBestEffort {
    param(
        [Parameter(Mandatory)][string]$Label,
        [Parameter(Mandatory)]$Jobs
    )
    if (-not $Jobs) { return }
    foreach ($job in @($Jobs)) {
        try {
            Wait-Job $job | Out-Null
            Receive-Job $job -ErrorAction SilentlyContinue | Out-Host
            if ($job.State -eq 'Failed') {
                Write-Warning "${Label} job failed (continuing)"
            }
        } catch {
            Write-Warning "${Label} wait failed (continuing): $_"
        } finally {
            Remove-Job $job -Force -ErrorAction SilentlyContinue
        }
    }
}
