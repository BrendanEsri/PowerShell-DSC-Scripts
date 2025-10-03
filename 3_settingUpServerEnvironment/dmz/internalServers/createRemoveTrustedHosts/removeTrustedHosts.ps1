# List of target machines
$remoteServers = @("Machine1", "Machine2", "Machine3")

# Script block to execute on each machine
$scriptBlock = {
    try {
        winrm set winrm/config/client '@{TrustedHosts=""}'
        Write-Host "TrustedHosts has been reset to default (empty value)."
    } catch {
        Write-Host "An error occurred: $_"
    }

    # Output the current winrm/config/client configuration
    $currentConfig = winrm get winrm/config/client
    Write-Host "Current winrm/config/client configuration:"
    $currentConfig | ForEach-Object { Write-Host $_ }
}

# Execute the script block on each target machine
foreach ($server in $remoteServers) {
    Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock
}