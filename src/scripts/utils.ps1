#Requires -Version 7
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Info([string]$m){ Write-Host "[INFO] $m" }
function Write-Warn([string]$m){ Write-Warning $m }

function Test-Cmd([string]$name){
  $null -ne (Get-Command $name -ErrorAction SilentlyContinue)
}

function Test-WingetInstalled([string]$id,[string]$name){
  $out = @()
  if ($id)   { $out += winget list -e --id $id   --accept-source-agreements 2>$null }
  if ($name) { $out += winget list -e --name $name --accept-source-agreements 2>$null }
  ($out -join "`n") -match '\S'
}

function Install-Winget {
  param(
    [Parameter(Mandatory)][string]$Id,
    [string]$Name = '',
    [string]$Source = '',
    [string[]]$Args = @('--silent','--accept-package-agreements','--accept-source-agreements')
  )
  if (Test-WingetInstalled -id $Id -name $Name) {
    Write-Info "$Id already installed"
    return
  }
  $base = @('install','-e','--id', $Id) + $Args
  if ($Source) { $base += @('-s', $Source) }
  Write-Info "winget $($base -join ' ')"
  winget @base
}

# Exact IDs
$Global:Pkg = @{
  # CLI / core
  git              = @{ Id='Git.Git' }
  ripgrep          = @{ Id='BurntSushi.ripgrep.MSVC' }
  fd               = @{ Id='sharkdp.fd' }
  bat              = @{ Id='sharkdp.bat' }
  eza              = @{ Id='eza-community.eza' }
  jq               = @{ Id='jqlang.jq' }
  wget             = @{ Id='JernejSimoncic.Wget' }
  curl             = @{ Id='curl.curl' }
  fastfetch        = @{ Id='Fastfetch-cli.Fastfetch' }
  vim              = @{ Id='vim.vim' }

  # Dev
  node             = @{ Id='OpenJS.NodeJS.LTS' }
  nvm              = @{ Id='CoreyButler.NVMforWindows' }
  python312        = @{ Id='Python.Python.3.12' }
  gh               = @{ Id='GitHub.cli' }
  neovim           = @{ Id='Neovim.Neovim' }
  docker           = @{ Id='Docker.DockerDesktop' }
  srccli           = @{ Id='Sourcegraph.src-cli' }
  semgrep          = @{ Id='Semgrep.Semgrep' }
  shellcheck       = @{ Id='koalaman.shellcheck' } # optional

  # GUI / browsers / media
  brave            = @{ Id='Brave.Brave' }
  ddg              = @{ Id='DuckDuckGo.DesktopBrowser' }
  vlc              = @{ Id='VideoLAN.VLC' }
  spotify          = @{ Id='Spotify.Spotify' }

  # Productivity
  chatgpt          = @{ Id='9NT1R1C2HH7J'; Source='msstore' } # Store app
  notion           = @{ Id='Notion.Notion' }
  protondrive      = @{ Id='Proton.ProtonDrive' }
  zoom             = @{ Id='Zoom.Zoom' }

  # Security / networking
  exiftool         = @{ Id='PhilHarvey.ExifTool' }
  nmap             = @{ Id='Insecure.Nmap' }
  openvpn          = @{ Id='OpenVPNTechnologies.OpenVPNConnect' }
  onepassword      = @{ Id='AgileBits.1Password' }
  onepassword_cli  = @{ Id='AgileBits.1Password.CLI' }
  burp             = @{ Id='PortSwigger.BurpSuite.Community' }
  zap              = @{ Id='ZAP.ZAP' }
  protonvpn        = @{ Id='Proton.ProtonVPN' }
  signal           = @{ Id='OpenWhisperSystems.Signal' }

  # Terminal / WSL
  terminal         = @{ Id='Microsoft.WindowsTerminal' }
  ohmyposh         = @{ Id='JanDeDobbeleer.OhMyPosh' }
  wsl              = @{ Id='Microsoft.WSL' }
  ubuntu2404       = @{ Id='Canonical.Ubuntu.2404' }
}

function Install-Pkg([string]$key){
  $p = $Global:Pkg[$key]
  if (-not $p) { Write-Warn "No mapping for $key"; return }
  Install-Winget -Id $p.Id -Name $p.Name -Source $p.Source
}

function Ensure-Dir([string]$Path){
  if (-not (Test-Path $Path)) { New-Item -ItemType Directory -Force -Path $Path | Out-Null }
}

function Copy-IfMissing([string]$Source,[string]$Destination){
  if (-not (Test-Path $Destination)) {
    Ensure-Dir (Split-Path $Destination -Parent)
    Copy-Item -Recurse -Force $Source $Destination
    Write-Info "Copied -> $Destination"
  } else { Write-Info "Exists: $Destination" }
}

