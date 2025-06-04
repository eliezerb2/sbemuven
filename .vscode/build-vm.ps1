param(
    [Parameter()]
    [string]$IsoPath,    # Path to local ISO file (optional)
    
    [Parameter()]
    [switch]$DebugMode,  # Run Packer in debug mode (optional)
    
    [Parameter()]
    [string]$IsoChecksum # Checksum for the ISO file (optional)
)

#-------------------------------------------------------
# Script to build Ubuntu VM using Packer
# 
# This script builds an Ubuntu VM using Packer with either
# a remote or local ISO file. It includes error handling
# and validation of required files and paths.
#-------------------------------------------------------

# Error handling setup - Make all errors terminating
$ErrorActionPreference = "Stop"
$packerPath = "C:\Program Files\packer\packer.exe"

try {
    # Check if Packer exists at the specified path
    if (-not (Test-Path -Path $packerPath)) {
        throw "Packer executable not found at $packerPath"
    }

    # Check if we're in the right directory structure
    $vmDir = "$PSScriptRoot\..\ubuntu-vm"
    if (-not (Test-Path -Path $vmDir)) {
        throw "Ubuntu VM directory not found at $vmDir"
    }

    # Change to the VM directory where Packer files are located
    Set-Location -Path $vmDir
    
    # Initialize Packer - This downloads required plugins
    Write-Host "Initializing Packer..." -ForegroundColor Cyan
    & $packerPath init -timestamp-ui .
    if ($LASTEXITCODE -ne 0) {
        throw "Packer initialization failed with exit code $LASTEXITCODE"
    }

    # Build command arguments array for Packer
    $buildArgs = @()
    
    # Add debug flag if specified
    if ($DebugMode) {
        $buildArgs += "-debug"
        Write-Host "Debug mode enabled - build will pause for confirmation at each step" -ForegroundColor Yellow
    }

    # Add ISO path if specified (for local ISO)
    if ($IsoPath) {
        # Validate that the ISO file exists
        if (-not (Test-Path -Path $IsoPath)) {
            throw "ISO file not found at $IsoPath"
        }
        Write-Host "Using local ISO: $IsoPath" -ForegroundColor Cyan
        $buildArgs += "-var", "iso_path=$IsoPath"
    } else {
        Write-Host "Using remote ISO (will be downloaded if not in cache)" -ForegroundColor Cyan
    }
    
    # Add ISO checksum if specified
    if ($IsoChecksum) {
        Write-Host "Using custom ISO checksum: $IsoChecksum" -ForegroundColor Cyan
        $buildArgs += "-var", "iso_checksum=$IsoChecksum"
    }

    # Add the current directory as the template source
    $buildArgs += "."

    # Run Packer build with the assembled arguments
    Write-Host "Starting Packer build..." -ForegroundColor Cyan
    & $packerPath build -timestamp-ui $buildArgs
    if ($LASTEXITCODE -ne 0) {
        throw "Packer build failed with exit code $LASTEXITCODE"
    }
    
    # Success message
    Write-Host "Build completed successfully!" -ForegroundColor Green
}
catch {
    # Error handling - Display error message and exit with non-zero code
    Write-Host "ERROR: $_" -ForegroundColor Red
    exit 1
}