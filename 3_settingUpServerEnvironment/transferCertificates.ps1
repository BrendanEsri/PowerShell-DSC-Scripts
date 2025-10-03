﻿# Brendan Bladdick and Adrien Hafner

# this script is designed to transfer certificates to all the machines in the $remoteServers block from the $localServer orchestration machine, and at the end of the script, it will report the contents of the folder on your remote servers so you can confirm the certificates have been transferred.

# change the $localServer and $remoteServers lists to reflect your machines

# change the $localDrive, $remoteDrive, $mainDirectory and $subDirectory to match your environment

# Define the local and remote servers
$localServer = @('localserver')   # The machine running the script
$remoteServers = @('remoteserver1','remoteserver2') # Remote targets

# Drive letter and file path setup
$localDrive = "D:" # Define the drive letter as a variable (no trailing slash or $)
$remoteDrive = "D:" # Define the drive letter as a variable (no trailing slash or $)
$mainDirectory = "Automation"  # Change this to the directory that contains the folder that contains the certificates folder
$subDirectory = "Certificates" # Change this to the directory that contains the certificates

# Source path on local machine
$sourcePath = Join-Path -Path $localDrive -ChildPath "$mainDirectory\$subDirectory\*"

# Loop through all target servers
foreach ($server in $localServer + $remoteServers) {
    $serverTrimmed = $server.Trim()

    if ($localServer -contains $serverTrimmed) {
        Write-Host "Skipping local server to avoid accidental overwrite: $serverTrimmed"
        continue
    }

    $driveShare = "$($remoteDrive.TrimEnd(':'))$"
    $targetDir = "\\$serverTrimmed\$driveShare\$mainDirectory\$subDirectory"

    try {
        # Ensure destination exists
        if (-not (Test-Path -Path $targetDir)) {
            Write-Host "Creating remote directory: ${targetDir}"
            New-Item -ItemType Directory -Path $targetDir -Force
        } else {
            Write-Host "Clearing existing contents in: ${targetDir}"
            Remove-Item "${targetDir}\*" -Recurse -Force
        }

        # Copy from local to remote
        Write-Host "Copying from ${sourcePath} to ${targetDir}"
        Copy-Item -Path $sourcePath -Destination $targetDir -Recurse -Force

        Write-Host "Files now at ${targetDir}:"
        Get-ChildItem -Path $targetDir -Recurse | ForEach-Object { Write-Host $_.FullName }

    } catch {
        Write-Error "Failed on ${serverTrimmed}: $_"
    }
}
