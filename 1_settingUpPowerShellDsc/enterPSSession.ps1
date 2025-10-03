#Adrien Hafner
#This script is designed to assist with confirming WinRM connectivity between an orchestration server and other servers in the deployment before attempting a PowerShellDSC install.  The script can also assist with troubleshooting if you feel there may be an issue with connecting from an orchestration or deployment server to remote servers in the environment. 
#If successful, this script should allow you to enter a PowerShell session on the remote computer specified.
#change the "Server1","Server2", Server3" text with your machine names


# List of servers
$servers = @("Server1", "Server2", "Server3")

# Loop through each server
foreach ($server in $servers) {
    try {
        # Enter the PSSession
        Enter-PSSession -ComputerName $server -ErrorAction Stop

        # Do any necessary tasks in the session here if needed (Optional)
        Write-Host "Entered session for $server"

    } catch {
        # Handle any errors if the connection fails
        Write-Host "Failed to connect to $server. Error: $_"
    } finally {
        # Exit the session
        Exit-PSSession
        Write-Host "Exited session for $server"
    }
}