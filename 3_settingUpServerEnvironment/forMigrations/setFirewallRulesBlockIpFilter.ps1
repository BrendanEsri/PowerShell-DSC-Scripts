# This script creates a new firewall rule to block inbound traffic from multiple IP addresses on multiple machines.

$remoteServers = @('machine1','machine2','machine3')  # List of machines to run the script on
$blockIPs = '192.168.1.1,10.0.0.1,172.16.0.1'  # List of IP addresses to block as a comma-separated string
$environment = "Target Non-Production"  # Name of the environment to block traffic from

# Convert the comma-separated string of IPs into an array
$blockIPsArray = $blockIPs -split ','

$parameters = @{
    ComputerName = $remoteServers
    ScriptBlock = {
        param($blockIPsArray, $environment)  # Accepts the block IPs array and environment as parameters

        # Validate each IP address
        foreach ($ip in $blockIPsArray) {
            if (-not [System.Net.IPAddress]::TryParse($ip, [ref]$null)) {
                Write-Error "Invalid IP address: $ip"
                return
            }
        }

        # Create a single firewall rule to block inbound traffic from all specified IPs
        New-NetFirewallRule -DisplayName "Block Multiple IPs from $environment" -Direction Inbound -Action Block -RemoteAddress $blockIPsArray -Profile Any
    }
    ArgumentList = ($blockIPsArray, $environment)  # Pass the $blockIPs array and $environment as arguments to the ScriptBlock
}

Invoke-Command @parameters


