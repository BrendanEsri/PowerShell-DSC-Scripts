# Brendan Bladdick

# This script sets the Local DSC configuration to Stop on Restart and to ApplyOnly so logs don't pile up

#change the machine1, machine2 with your machines
#if only one machine in deployment then can simply run the contents of the invoke command
$remoteServers = @('machine1','machine2')

foreach ($server in $remoteServers) {
    Write-Host "Connecting to $server";
    $session = New-PSSession -ComputerName $server;
    Invoke-Command -Session $session -ScriptBlock {
        Write-Host 'Setting Local DSC Configuration Manager to ApplyOnly and Stop Configuration';
        Set-Location C:\Windows\System32;
        [DSCLocalConfigurationManager()]
        configuration LCMConfig {
            Node localhost {
                Settings {
                    ConfigurationMode='ApplyOnly'
                    ActionAfterReboot = 'StopConfiguration'
                }
            }
        }
        LCMConfig;
        Set-DscLocalConfigurationManager -Path 'C:\Windows\System32\LCMConfig' -Force;
        Write-Host 'Local DSC Configuration Manager is now set to ApplyOnly';
    }
    Write-Host "Disconnected from $server";
    Remove-PSSession $session;
}
