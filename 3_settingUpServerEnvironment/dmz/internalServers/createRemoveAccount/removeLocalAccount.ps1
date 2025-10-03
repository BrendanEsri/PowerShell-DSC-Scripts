# Variables
$username = "dmzUser"
# List of target machines
$remoteServers = @("Machine1", "Machine2", "Machine3")

# Script block to execute on each machine
$scriptBlock = {
    param($username)

    try {
        # Remove user from the Administrators group (if added)
        if (Get-LocalGroupMember -Group "Administrators" -Member $username -ErrorAction SilentlyContinue) {
            Remove-LocalGroupMember -Group "Administrators" -Member $username
            Write-Host "User $username removed from Administrators group."
        } else {
            Write-Host "User $username was not a member of the Administrators group."
        }

        # Remove the local user
        if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
            Remove-LocalUser -Name $username
            Write-Host "Local user $username removed successfully."
        } else {
            Write-Host "Local user $username does not exist."
        }
    } catch {
        Write-Host "An error occurred: $_"
    }
}

# Execute the script block on each target machine
foreach ($server in $remoteServers) {
    Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock -ArgumentList $username
}