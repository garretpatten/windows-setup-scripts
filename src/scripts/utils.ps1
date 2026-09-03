#Requires -Version 7
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Info([string]$m){ Write-Host "[INFO] $m" }
function Write-Warn([string]$m){ Write-Warning $m }

function Test-Cmd([string]$name){
  $null -ne (Get-Command $name -ErrorAction SilentlyContinue)
}

$Global:DotfilesRoot = Join-Path (Split-Path -Parent $PSScriptRoot) 'dotfiles'

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
  btop             = @{ Id='aristocratos.btop4win' }
  fzf              = @{ Id='junegunn.fzf' }
  zoxide           = @{ Id='ajeetdsouza.zoxide' }
  tree_sitter      = @{ Id='tree-sitter.tree-sitter-cli' }
  make             = @{ Id='ezwinports.make' }
  lazygit          = @{ Id='JesseDuffield.lazygit' }
  lazydocker       = @{ Id='JesseDuffield.Lazydocker' }
  yazi             = @{ Id='sxyazi.yazi' }

  # Dev
  node             = @{ Id='OpenJS.NodeJS.LTS' }
  go               = @{ Id='GoLang.Go' }
  nvm              = @{ Id='CoreyButler.NVMforWindows' }
  python312        = @{ Id='Python.Python.3.12' }
  gh               = @{ Id='GitHub.cli' }
  neovim           = @{ Id='Neovim.Neovim' }
  docker           = @{ Id='Docker.DockerDesktop' }
  srccli           = @{ Id='Sourcegraph.src-cli' }
  semgrep          = @{ Id='Semgrep.Semgrep' }
  shellcheck       = @{ Id='koalaman.shellcheck' } # optional
  rustup           = @{ Id='Rustlang.Rustup' }
  ollama           = @{ Id='Ollama.Ollama' }
  ruby             = @{ Id='RubyInstallerTeam.Ruby.3.4' }
  cursor           = @{ Id='Anysphere.Cursor' }

  # GUI / browsers / media
  brave            = @{ Id='Brave.Brave' }
  chrome           = @{ Id='Google.Chrome' }
  ddg              = @{ Id='DuckDuckGo.DesktopBrowser' }
  vlc              = @{ Id='VideoLAN.VLC' }
  spotify          = @{ Id='Spotify.Spotify' }
  ffmpeg           = @{ Id='Gyan.FFmpeg' }

  # Productivity
  chatgpt          = @{ Id='9NT1R1C2HH7J'; Source='msstore' } # Store app
  notion           = @{ Id='Notion.Notion' }
  protondrive      = @{ Id='Proton.ProtonDrive' }
  zoom             = @{ Id='Zoom.Zoom' }
  flameshot        = @{ Id='Flameshot.Flameshot' }
  keepassxc        = @{ Id='KeePassXCTeam.KeePassXC' }
  libreoffice      = @{ Id='TheDocumentFoundation.LibreOffice' }
  etcher           = @{ Id='Balena.Etcher' }

  # Security / networking
  exiftool         = @{ Id='PhilHarvey.ExifTool' }
  nmap             = @{ Id='Insecure.Nmap' }
  openvpn          = @{ Id='OpenVPNTechnologies.OpenVPNConnect' }
  onepassword      = @{ Id='AgileBits.1Password' }
  onepassword_cli  = @{ Id='AgileBits.1Password.CLI' }
  burp             = @{ Id='PortSwigger.BurpSuite.Community' }
  zap              = @{ Id='ZAP.ZAP' }
  protonvpn        = @{ Id='Proton.ProtonVPN' }
  protonpass       = @{ Id='Proton.ProtonPass' }
  signal           = @{ Id='OpenWhisperSystems.Signal' }

  # Web / API
  bruno            = @{ Id='Bruno.Bruno' }

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

$Global:XdgConfigScope = @{
  alacritty  = 'Roaming'
  yazi       = 'Roaming'
  pip        = 'Roaming'
  lazygit    = 'Roaming'
  zsh        = 'Local'
  nvim       = 'Local'
  tmux       = 'Local'
  fastfetch  = 'Local'
  ghostty    = 'Roaming'
  opencode   = 'Roaming'
  kitty      = 'Local'
  githooks   = 'Local'
  ohmyposh   = 'Local'
  zellij     = 'Local'
  btop       = 'Local'
  uv         = 'Roaming'
}

function Get-XdgConfigPath([string]$name){
  $scope = if ($Global:XdgConfigScope.ContainsKey($name)) { $Global:XdgConfigScope[$name] } else { 'Local' }
  $base = if ($scope -eq 'Roaming') { $env:APPDATA } else { $env:LOCALAPPDATA }
  return Join-Path $base $name
}

function Install-DotfilesConfigDir([string]$name){
  $src = Join-Path $Global:DotfilesRoot 'config' $name
  if (-not (Test-Path $src)) { return }
  $target = Get-XdgConfigPath $name
  if (Test-Path $target) {
    $existing = Get-Item $target -ErrorAction SilentlyContinue
    if ($existing -and $existing.Target -contains $src) { return }
    $bak = "$target.dotfiles-bak-$(Get-Date -Format 'yyyyMMddHHmmss')"
    Move-Item $target $bak -Force
    Write-Info "Backed up existing $target -> $bak"
  }
  Ensure-Dir (Split-Path $target -Parent)
  try {
    New-Item -ItemType SymbolicLink -Path $target -Target $src -Force -ErrorAction Stop | Out-Null
    Write-Info "Linked config -> $target"
  } catch {
    Copy-Item -Recurse -Force $src $target
    Write-Info "Copied config -> $target (symlink failed: $_)"
  }
}

function Install-DotfilesHomeFile([string]$name){
  $src = Join-Path $Global:DotfilesRoot 'home' $name
  if (-not (Test-Path $src)) { return }
  $dst = Join-Path $HOME $name
  Copy-IfMissing $src $dst
}

