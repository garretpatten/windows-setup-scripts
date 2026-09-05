#Requires -Version 7

$script:Failures = 0

function Write-Section([string]$Name) {
    Write-Host "`n== $Name =="
}

function Write-Pass {
    param([string]$Name, [string]$Detail = '')
    if ($Detail) {
        Write-Host ("  ok  {0,-28} {1}" -f $Name, $Detail)
    } else {
        Write-Host ("  ok  {0}" -f $Name)
    }
}

function Write-Fail {
    param([string]$Name, [string]$Detail = 'not found')
    Write-Host ("  FAIL {0,-28} {1}" -f $Name, $Detail) -ForegroundColor Red
    $script:Failures++
}

function Test-CommandOnPath {
    param([string]$Name, [string]$Bin)
    $cmd = Get-Command $Bin -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Pass $Name $cmd.Source
    } else {
        Write-Fail $Name "command not in PATH: $Bin"
    }
}

function Test-VersionCmd {
    param([string]$Name, [scriptblock]$Block)
    try {
        $out = & $Block 2>$null | Select-Object -First 1
        if ($LASTEXITCODE -and $LASTEXITCODE -ne 0 -and -not $out) {
            Write-Fail $Name
        } else {
            Write-Pass $Name ("{0}" -f $out)
        }
    } catch {
        Write-Fail $Name $_.Exception.Message
    }
}

function Test-PathExists {
    param([string]$Name, [string]$Path)
    if (Test-Path -LiteralPath $Path) {
        Write-Pass $Name $Path
    } else {
        Write-Fail $Name "missing path: $Path"
    }
}

function Test-WingetId {
    param([string]$Name, [string]$Id)
    $out = winget list -e --id $Id --accept-source-agreements 2>$null | Out-String
    if ($out -match [regex]::Escape($Id)) {
        Write-Pass $Name $Id
    } else {
        Write-Fail $Name "winget id missing: $Id"
    }
}

function Complete-Validation {
    param([string]$Label)
    Write-Host ''
    if ($script:Failures -gt 0) {
        Write-Host "$Label failed: $($script:Failures) check(s)." -ForegroundColor Red
        exit 1
    }
    Write-Host "$Label passed."
}
