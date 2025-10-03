# Brendan Bladdick
#
# this script is designed to transfer arcgis module to all the machines in the @arcgisservers block from a local directory on the machine that has the arcgis module

# change the machine1, machine2 with your machines

# Do not include the machine that has the arcgis module on it inside of the @arcgisservers block or it will remove your arcgis module
 
$remoteServers = @('machine1','machine2')

$ScriptBlock = {
    param ($server)
    # Define the target directory path
    $targetDir = "\\$server\c$\Program Files\WindowsPowerShell\Modules"
    
    # If the directory already exists, remove its contents
    if (Test-Path -Path "$targetDir\ArcGIS") {
        Remove-Item "$targetDir\ArcGIS" -Recurse -Force
    }
    else {
        Write-Host "The ArcGIS Module is not installed on $server"
    }
    
    # Now, copy the folder of the source licenses folder to the target
    Copy-Item -Path "C:\Program Files\WindowsPowerShell\Modules\ArcGIS" -Destination $targetDir -Recurse -Force
}

$jobs = @()
foreach ($server in $remoteServers) {
    $job = Start-Job -ScriptBlock $ScriptBlock -ArgumentList $server
    $jobs += $job
}

# Wait for all jobs to complete
$jobs | Wait-Job

# Output job results and cleanup
$jobs | ForEach-Object {
    Receive-Job -Job $_
    Remove-Job -Job $_
}
