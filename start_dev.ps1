# Determine the correct path to node executable
$localBin = "$PSScriptRoot\nodejs-bin"
$nodeDir = Get-ChildItem -Path $localBin -Directory -Filter "node-v*-win-x64" | Select-Object -First 1

if (-not $nodeDir) {
    Write-Host "Node.js binary folder not found in $localBin."
    exit 1
}

$NodePath = $nodeDir.FullName
$NodeExe = "$NodePath\node.exe"
$NpmCli = "$NodePath\node_modules\npm\bin\npm-cli.js"

if (-not (Test-Path $NodeExe)) { Write-Host "node.exe not found"; exit 1 }
if (-not (Test-Path $NpmCli)) { Write-Host "npm-cli.js not found"; exit 1 }

Write-Host "Using portable Node.js from: $NodePath"

# Function to run npm
function npm {
    & $NodeExe $NpmCli $args
}

# Add to PATH (for node)
$env:Path = "$NodePath;$env:Path"

# Verify versions
Write-Host "Node Version: $(& $NodeExe -v)"
Write-Host "NPM Version: $(npm -v)"

# Install dependencies
if (-not (Test-Path "$PSScriptRoot\node_modules")) {
    Write-Host "Installing dependencies..."
    npm install
}

# Run dev server
Write-Host "Starting development server..."
npm run dev
