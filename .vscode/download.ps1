$url = "https://releases.ubuntu.com/22.04.4/ubuntu-22.04.4-live-server-amd64.iso"
# Ensure the directory exists
$outputDir = "ubuntu-vm/packer_cache"
if (-not (Test-Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory -Force | Out-Null
}
$output = "$outputDir/ubuntu-22.04.4-live-server-amd64.iso"

# Start BITS transfer with robust settings
$job = Start-BitsTransfer `
    -Source $url `
    -Destination $output `
    -DisplayName "Downloading Ubuntu ISO" `
    -Description "Ubuntu 22.04.4 LTS Server (amd64)" `
    -Priority Foreground `  # Ensures faster download
    -RetryInterval 60 `    # Retry every 60 seconds if interrupted
    -RetryTimeout 3600 `   # Keep retrying for up to 1 hour
    -Asynchronous         # Allows monitoring while running

# Monitor progress (optional)
while ($job.JobState -in @("Connecting", "Transferring", "Queued")) {
    $progress = [math]::Round(($job.BytesTransferred / $job.BytesTotal) * 100, 2)
    Write-Progress -Activity "Downloading Ubuntu ISO" -Status "$progress% Complete" -PercentComplete $progress
    Start-Sleep -Seconds 5
}

# Completion check
switch ($job.JobState) {
    "Transferred" { 
        Complete-BitsTransfer -BitsJob $job
        Write-Host "Download completed successfully!" -ForegroundColor Green
    }
    "Error" { Write-Host "Download failed: $($job.ErrorDescription)" -ForegroundColor Red }
    "Suspended" { Write-Host "Download paused. Resume with: Resume-BitsTransfer -BitsJob `$job" -ForegroundColor Yellow }
}