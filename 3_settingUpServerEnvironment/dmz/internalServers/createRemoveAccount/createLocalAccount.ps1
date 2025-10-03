# Variables
$username = "dmzUser"
$description = "Local user for DMZ and Non-DMZ machines"
$password = Read-Host "Enter password for the new user" -AsSecureString

# List of target machines
$remoteServers = @("Machine1", "Machine2", "Machine3")

# Script block to execute on each machine
$scriptBlock = {
    param($username, $password, $description)

    try {
        # Create local user
        if (-not (Get-LocalUser -Name $username -ErrorAction SilentlyContinue)) {
            New-LocalUser -Name $username -Password $password -Description $description
            Write-Host "Local user $username created successfully."
        } else {
            Write-Host "Local user $username already exists."
        }

        # Add user to the Administrators group
        if (-not (Get-LocalGroupMember -Group "Administrators" -Member $username -ErrorAction SilentlyContinue)) {
            Add-LocalGroupMember -Group "Administrators" -Member $username
            Write-Host "User $username added to Administrators group."
        } else {
            Write-Host "User $username is already a member of the Administrators group."
        }
    } catch {
        Write-Host "An error occurred: $_"
    }
}

# Execute the script block on each target machine
foreach ($server in $remoteServers) {
    Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock -ArgumentList $username, $password, $description
}
