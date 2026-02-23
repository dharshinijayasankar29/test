$fnmPath = "$env:LOCALAPPDATA\Microsoft\WinGet\Links\fnm.exe"
if (-not (Test-Path $fnmPath)) {
    $fnmPath = "$env:APPDATA\fnm\fnm.exe"
}
if (-not (Test-Path $fnmPath)) {
    # Try generic search
    $fnmPath = Get-Command fnm -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
}

if (-not $fnmPath -or -not (Test-Path $fnmPath)) {
    Write-Host "FNM tool not found. Please restart your terminal."
    exit 1
}

Write-Host "Found FNM at $fnmPath"
$env:Path = "$(Split-Path $fnmPath);$env:Path"

# Install Node
Write-Host "Installing Node LTS..."
& $fnmPath install --lts
& $fnmPath use lts

# Setup Env for Node
$envBlock = & $fnmPath env --use-on-cd
$envBlock | Out-String | Invoke-Expression

Write-Host "Node Version: $(node -v)"
Write-Host "NPM Version: $(npm -v)"

# Install dependencies
Write-Host "Installing dependencies..."
npm install
