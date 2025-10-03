# This script sets the firewall rules on the specified machines to allow inbound traffic on the specified ports.

# Define the list of machines to set the firewall rules on
$remoteServers = @('machine1', 'machine2', 'machine3')

# Define the ports
$ports = 80, 135, 443, 445, 2443, 5985, 5986, 6080, 6443, 7080, 7443, 9320, 9220, 9829, 20443, 20301, 21443, 29080, 29081, 29878, 29879, 45672, 45671

# Convert the ports array to a comma-separated string
$portsString = $ports -join ','

# Define the name and description of the rule
$ruleName = "Allow Inbound ArcGIS Enterprise, Automation and File Share traffic"
$ruleDescription = "Allows inbound traffic on ports: $portsString"

# Define the script block to be executed on each machine
$scriptBlock = {
    param($ports, $ruleName, $ruleDescription)

    # Create the firewall rule for the Domain profile
    New-NetFirewallRule -DisplayName $ruleName -Description $ruleDescription -Direction Inbound -Action Allow -Protocol TCP -LocalPort $ports -Profile Domain, Private

    Write-Output "Firewall rules created successfully for Domain and Private profiles on $env:COMPUTERNAME."
}

# Iterate through each machine and execute the script block
foreach ($server in $remoteServers) {
    Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock -ArgumentList $ports, $ruleName, $ruleDescription
}
