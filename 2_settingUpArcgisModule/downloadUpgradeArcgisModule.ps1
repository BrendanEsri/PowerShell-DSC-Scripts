# Brendan Bladdick

# connects to each machine in the arcgisservers array and removes the old ArcGIS module from the machine then installs the new module

# change the machine1, machine2 with your machines

$remoteServers = ("machine1","machine2")

# Start a new job for each server
$jobs = $remoteServers | ForEach-Object {
    $server = $_
    Start-Job -ScriptBlock {
        param($server)
        Write-Host "Connecting to $server"
        $session = New-PSSession -ComputerName $server
        Invoke-Command -Session $session -ScriptBlock {
            Remove-Item -Path "C:\Program Files\WindowsPowerShell\Modules\ArcGIS" -Recurse -Force -ErrorAction SilentlyContinue
            # Set the security protocol to TLS 1.2
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            # Install NuGet provider
            Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
            #install new module to this machine
            Install-Module ArcGIS -Force
        }
    } -ArgumentList $server
}

# Wait for all jobs to complete
$jobs | Wait-Job

# Get the results of the jobs and print them
$jobs | Receive-Job | ForEach-Object { Write-Host $_ }

# Clean up the jobs
$jobs | Remove-Job