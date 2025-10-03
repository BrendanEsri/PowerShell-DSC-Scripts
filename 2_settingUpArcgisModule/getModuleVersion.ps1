##Adrien Hafner
##This script will report on which version of the ArcGIS PowerShell DSC module is installed on each of the servers in the list you provide the script.
##This information can be helpful when determining whether or not the ArcGIS module version needs upgraded, and also indicates when there is more than one version of the module installed (this can sometimes cause issues and is not recommended).

$remoteServers = @("Server1","Server2","Server3")

foreach ($server in $remoteServers) {
    try {
        # Run Get-Module remotely on each server
        $modules = Invoke-Command -ComputerName $server -ScriptBlock {
            Get-Module -ListAvailable -Name 'ArcGIS'
        }
        
        # If modules are found, output the result
        if ($modules) {
            Write-Host "ArcGIS modules on ${server}:"
            $modules
        }
        else {
            Write-Host "No ArcGIS modules found on ${server}."
        }
    }
    catch {
        # If an error occurs, output the failure message
        Write-Host "Unable to get version on ${server}"
    }
}
