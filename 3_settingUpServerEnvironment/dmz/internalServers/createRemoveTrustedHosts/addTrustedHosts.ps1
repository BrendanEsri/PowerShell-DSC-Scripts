# List of target machines
$remoteServers = @("Machine1", "Machine2", "Machine3")

# Trusted hosts array
$trustedHosts = @(
    "192.168.1.1",  # Replace with your IP addresses
    "192.168.1.2",
    "hostname1.domain.com",  # Replace with your hostnames
    "hostname2.domain.com"
)

# Convert the array to a comma-separated string
$trustedHostsString = $trustedHosts -join ','

# Script block to execute on each machine
$scriptBlock = {
    param($trustedHostsString)
    $input = "@{TrustedHosts=`"$trustedHostsString`"}"
    try {
        winrm set winrm/config/client $input
        Write-Host "TrustedHosts set to: $trustedHostsString"
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
    Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock -ArgumentList $trustedHostsString
}