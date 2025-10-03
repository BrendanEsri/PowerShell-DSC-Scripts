# Brendan Bladdick

# change the machine1, machine2 with your machines
# This script sets the Local DSC configuration to Stop on Restart and to ApplyOnly so logs don't pile up and so it won't run again on restart 

$remoteServers = @('machine1','machine2')

foreach ($server in $remoteServers) {
    Write-Host "Connecting to $server";
    $session = New-PSSession -ComputerName $server;
    Invoke-Command -Session $session -ScriptBlock {
        Write-Host 'clearing dsc config';
        Remove-DscConfigurationDocument -Stage Current, Pending, Previous -Verbose -Force;
        Write-Host 'cleared dsc config';
    }
    Write-Host "Disconnected from $server";
    Remove-PSSession $session;
}