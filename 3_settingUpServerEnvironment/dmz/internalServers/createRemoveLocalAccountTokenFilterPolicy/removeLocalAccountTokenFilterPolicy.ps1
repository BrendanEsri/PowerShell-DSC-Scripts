# List of target machines
$remoteServers = @("Machine1", "Machine2", "Machine3")

# Script block to execute on each machine
$scriptBlock = {
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    $regName = "LocalAccountTokenFilterPolicy"

    try {
        if (Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue) {
            Remove-ItemProperty -Path $regPath -Name $regName -Force
            Write-Output "LocalAccountTokenFilterPolicy registry entry removed successfully."
        } else {
            Write-Output "LocalAccountTokenFilterPolicy registry entry does not exist."
        }
    } catch {
        Write-Output "An error occurred: $_"
    }

    # Verify the removal
    try {
        Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop
        Write-Output "Failed to remove LocalAccountTokenFilterPolicy registry entry."
    } catch {
        Write-Output "LocalAccountTokenFilterPolicy registry entry is confirmed as removed."
    }
}

# Execute the script block on each target machine
foreach ($server in $remoteServers) {
    Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock
}