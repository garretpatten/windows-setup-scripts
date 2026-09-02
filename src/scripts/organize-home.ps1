#Requires -Version 7
. "$PSScriptRoot/utils.ps1"

$folders = @(
  "$HOME\Code",
  "$HOME\Tools",
  "$HOME\Security",
  "$HOME\Media",
  "$HOME\tmp",
  "$HOME\Hacking",
  "$HOME\Projects\opensource",
  "$HOME\Projects\personal"
)
$folders | ForEach-Object { Ensure-Dir $_ }

# Clone common security reference repositories (mirror ubuntu hacking-repos.sh)
$hackingRepos = @(
  @{ Url='https://github.com/swisskyrepo/PayloadsAllTheThings'; Path="$HOME\Hacking\PayloadsAllTheThings" },
  @{ Url='https://github.com/danielmiessler/SecLists'; Path="$HOME\Hacking\SecLists" }
)
foreach ($repo in $hackingRepos) {
  if (-not (Test-Path $repo.Path)) {
    git clone --depth 1 --filter=blob:none $repo.Url $repo.Path 2>$null | Out-Null
    Write-Info "Cloned $($repo.Url)"
  } else {
    Write-Info "Exists: $($repo.Path)"
  }
}

