> ⚠️ **This repository is deprecated! Please visit our new repo:** [Esri PS PowerShell DSC Helper Scripts](https://github.com/EsriPS/PowerShell-DSC-HelperScripts)












# ArcGIS PowerShell DSC Helper Scripts

A series of helper scripts have been developed to assist with both setting up and configuring the PowerShell DSC environment, as well as making the ArcGIS deployment more standardized and seamless. Below is a brief description of some of them:

## [1_settingUpPowerShellDsc folder](./1_settingUpPowerShellDsc/)
<mark>You should run both of these scripts for each deployment.</mark>

- [**clearDscCache.ps1**](./1_settingUpPowerShellDsc/clearDscCache.ps1)
    - This script is good to run before and after running the Invoke-ArcGISConfiguration command, as it clears out any of the configuration settings currently in place within the PowerShell DSC module on the machine(s) specified. It’s good to run it twice, as well. The first time, it should clear out any settings. Running it again will allow you to confirm by looking at the console outputs that nothing is pending and that everything has in fact been reset/cleared.

- [**localLcmSet.ps1**](./1_settingUpPowerShellDsc/localLcmSet.ps1)
    - This script sets the local DSC configuration by updating the LCM (local configuration manager) for each machine to ‘ApplyOnly’ configuration mode, and ‘StopConfiguration’ action after reboot. The ‘ApplyOnly’ configuration mode is not the default LCM setting but works best with PowerShell DSC deployments like we use for installing and upgrading Enterprise. What it does is specify that the LCM applies the configuration only, and then does not continue to monitor for changes and write logs about any drift. The ‘ApplyOnly’ setting essentially says “do what the script is telling you to do right now, and then nothing else until another script tells you to do something else, explicitly”. The ‘StopConfiguration’ setting for the action after reboot says that in the event the machine gets rebooted, the process will be stopped and upon reboot, the DSC process will not try to restart automatically.  Run this script after running the clearDscCache.ps1 script to reset the DSC environment variables.

- [**enterPSSession.ps1**](./1_settingUpPowerShellDsc/enterPSSession.ps1)
    - This script attempts to connect to the remote server specified, and then open a new PowerShell session on that server.  This script can be helpful for testing general connectivity between an orchestration or deployment server and a remote server that it's using PowerShellDSC to control or configure before attempting to deploy with PowerShellDSC.  This script can also be used for troubleshooting connectivity issues between the orchestration server and other servers in the deployment.

## [2_settingUpArcgisModule folder](./2_settingUpArcgisModule/)
<mark>The scripts in this folder should be run situationally, with the help of the descriptions provided below.  You may need to use just one or a combination of them in your deployment</mark>

-  [**getModuleVersion.ps1**](./2_settingUpArcgisModule/getModuleVersion.ps1)
    - This script will report on which version of the ArcGIS PowerShell DSC module is installed on each of the servers in the list you provide the script.  This information can be helpful when determining whether or not the ArcGIS module version needs upgraded, and also indicates when there is more than one version of the module installed (this can sometimes cause issues and is generally not recommended).


-  [**installModule.ps1**](./2_settingUpArcgisModule/installModule.ps1)
    - This script will download the ArcGIS PowerShell module onto a single machine, such as an orchestration or deployment server.  Once the ArcGIS module is installed on the single machine using this script, the transferModule.ps1 script can be used to transfer the ArcGIS module to other machines in the deployment.  
    
    Note: this script requires internet access for the machine it is run from.

-  [**downloadUpgradeArcgisModule.ps1**](./2_settingUpArcgisModule/downloadUpgradeArcgisModule.ps1)
    - This script will remove any ArcGIS Modules from the machines in the list and install the most up to date ArcGIS Module to each machine. If you do not want the most recent version, download the desired version from GitHub and utilize the script within the transferScripts folder that will transfer the module from the Orchestration machine to the list of remote servers in the $arcgisservers variable.  
    
    Note: this script requires internet access for each of the machines listed in the script.  If the machines in your deployment do not have internet access, manually remove the old module(s) on the servers in the deployment, and then use the transferModule.ps1 script to transfer the desired ArcGIS module to the servers.

- [**transferModule.ps1**](./2_settingUpArcGISModule/transferModule.ps1)
    - this script will transfer the local arcgis PowerShell module (without upgrading it) to a list of remote servers provided in the script. This is useful if utilizing an older version of the PowerShell DSC ArcGIS Module. Make sure not to include the orchestrating machine in the list of $arcgisservers. It's important to note that if you have manually downloaded the arcgis module from the Github repository (instead of using the Install-Module command), you should right-click on the .zip file before unzipping it, go to Properties and check the "unblock" box, and then unzip the arcgis module file and place it in the PowerShell directory.  
    
    Note: this script can be used with or without internet access.

## [3_settingUpServerEnvironment folder](./3_settingUpServerEnvironment/)

- [**generatePwFiles.ps1**](./3_settingUpServerEnvironment/generatePwFiles.ps1)
<mark>This script will be helpful in most deployments.</mark>
    - This script allows for the generation of the password files that can be used in place of hard-coded password values in the JSON configuration file. Note: Once you specify the location of the password files in the script and run the script, the password files cannot be moved, or they will break. This is intentional. So, decide where you’d like for them to be located, make sure that path is specified in the script as well as the JSON configuration file, and then run the script. Note that the password files can only be used by the user who created them on the machine they were created on, within the folder they were created. This is for security purposed. The password files only need to be created on the machine that is being used to orchestrate the Invoke-ArcGISConfiguration command.

- [**transferCertificates.ps1**](./3_settingUpServerEnvironment/transferCertificates.ps1)
<mark>This script will be helpful in most deployments.</mark>
    - this script will transfer the contents of a ‘certificates’ folder on an orchestration machine, or the local machine to remote servers to be used for the deployment. Make sure not to include the orchestrating machine in the list of $arcgisservers.

- [**transferLicenses.ps1**](./3_settingUpServerEnvironment/transferLicenses.ps1)
<mark>This script will be helpful in most deployments.</mark>
    - this script will transfer the contents of a ‘licenses’ folder from a local location to a list of machines specified for each ArcGIS component. Make sure not to include the orchestrating machine in the list of $arcgisservers.

- [**transferOdbc.ps1**](./3_settingUpServerEnvironment/transferOdbc.ps1)
<mark>This script can be used if you're deploying a SQLServerClient role to a remote server in your deployment.</mark>
    - this script will transfer the contents of an ‘odbc’ folder from a local location to a list of machines specified for each ArcGIS component. Make sure not to include the orchestrating machine in the list of $arcgisservers.

- [**avExceptions.ps1**](./3_settingUpServerEnvironment/avExceptions.ps1)
<mark>This script is optional.</mark>
    - This script excludes common AGE folders from the Windows Defender Firewall program. Note that some environments may have this setting managed by GPO and/or may have external Firewalls.  If this is the case, this script may not address all scenarios. Please discuss with IT on how the Firewall environment is being managed.

- [**setFirewallRulesAllowAge.ps1**](./3_settingUpServerEnvironment/setFirewallRulesAllowAge.ps1)
<mark>This script is optional.</mark>
    - This script sets up firewall rules on a list of specified machines to allow inbound traffic on designated ports. It is designed to facilitate the configuration of firewall settings for ArcGIS Enterprise by opening necessary ports for various services. Note that some environments may have this setting managed by GPO and/or may have external Firewalls.  If this is the case, this script may not address all scenarios. Please discuss with IT on how the Firewall environment is being managed.

### [dmz folder](./3_settingUpServerEnvironment/dmz)
<mark>These scripts can be used when there are components to install and configure with PowerShellDSC that reside inside of a DMZ. The 'local' folder represents scripts that should be run in the DMZ environment, while the 'remote' folder represents scripts that should be run on/against the servers in the internal network.</mark>

#### [dmzServer folder](./3_settingUpServerEnvironment/dmz/dmzServer)
The scripts in this folder are designed to be run on the DMZ server(s).

##### [createRemoveAccount folder](./3_settingUpServerEnvironment/dmz/dmzServer/createRemoveAccount/)

- [**createLocalAccount.ps1**](./3_settingUpServerEnvironment/dmz/dmzServer/createRemoveAccount/createLocalAccount.ps1)
    - This script will create a local user account on the DMZ server(s).

- [**removeLocalAccount.ps1**](./3_settingUpServerEnvironment/dmz/dmzServer/createRemoveAccount/removeLocalAccount.ps1)
    - This script will remove a local user account from the Administrators group and then delete the account on the DMZ server(s).

##### [createRemoveLocalAccountTokenFilterPolicy folder](./3_settingUpServerEnvironment/dmz/dmzServer/createRemoveLocalAccountTokenFilterPolicy/)

- [**setLocalAccountTokenFilterPolicy.ps1**](./3_settingUpServerEnvironment/dmz/dmzServer/createRemoveLocalAccountTokenFilterPolicy/setLocalAccountTokenFilterPolicy.ps1)
    - This script will create a LocalAccountTokenFilterPolicy and set the value to 1.  What this does is grant remote connections from all local members of the Administrators group full high-integrity tokens during negotiation.  This should only be used on a temporary basis while deploying using PowerShellDSC.  After the deployment is complete, the corresponding removeLocalAccountTokenFilterPolicy.ps1 script should be used to remove the policy.

- [**removeLocalAccountTokenFilterPolicy.ps1**](./3_settingUpServerEnvironment/dmz/dmzServer/createRemoveLocalAccountTokenFilterPolicy/removeLocalAccountTokenFilterPolicy.ps1)
    - This script will remove a LocalAccountTokenFilterPolicy.  What this policy does is grant remote connections from all local members of the Administrators group full high-integrity tokens during negotiation.  After the PowerShellDSC deployment is complete, this policy should be removed as an additional security measure.

##### [createRemoveTrustedHosts folder](./3_settingUpServerEnvironment/dmz/dmzServer/createRemoveTrustedHosts/)

- [**addTrustedHosts.ps1**](./3_settingUpServerEnvironment/dmz/dmzServer/createRemoveTrustedHosts/addTrustedHosts.ps1)
    - This script will create a comma-separated string of IP addresses and hostnames of internal server machines and sets the TrustedHosts configuration setting for WinRM on the DMZ server(s).

- [**removeTrustedHosts.ps1**](./3_settingUpServerEnvironment/dmz/dmzServer/createRemoveTrustedHosts/removeTrustedHosts.ps1)
    - This script will reset the TrustedHosts list on the DMZ server(s) back to its default value, which is an empty list.

#### [internalServers folder](./3_settingUpServerEnvironment/dmz/internalServers)
The scripts in this folder are designed to be run on the internal orchestration/deployment server and target the other internal server(s) in the deployment.

##### [createRemoveAccount folder](./3_settingUpServerEnvironment/dmz/internalServers/createRemoveAccount/)

- [**createLocalAccount.ps1**](./3_settingUpServerEnvironment/dmz/internalServers/createRemoveAccount/createLocalAccount.ps1)
    - This script will create a local user account on the internal server(s) passed as a list in the script.

- [**removeLocalAccount.ps1**](./3_settingUpServerEnvironment/dmz/internalServers/createRemoveAccount/removeLocalAccount.ps1)
    - This script will remove a local user account from the Administrators group and then delete the account on the internal server(s) passed as a list in the script.

##### [createRemoveLocalAccountTokenFilterPolicy folder](./3_settingUpServerEnvironment/dmz/internalServers/createRemoveLocalAccountTokenFilterPolicy/)

- [**setLocalAccountTokenFilterPolicy.ps1**](./3_settingUpServerEnvironment/dmz/internalServers/createRemoveLocalAccountTokenFilterPolicy/setLocalAccountTokenFilterPolicy.ps1)
    - This script will create a LocalAccountTokenFilterPolicy and set the value to 1.  What this does is grant remote connections from all local members of the Administrators group full high-integrity tokens during negotiation.  This should only be used on a temporary basis while deploying using PowerShellDSC.  After the deployment is complete, the corresponding removeLocalAccountTokenFilterPolicy.ps1 script should be used to remove the policy.

- [**removeLocalAccountTokenFilterPolicy.ps1**](./3_settingUpServerEnvironment/dmz/internalServers/createRemoveLocalAccountTokenFilterPolicy/removeLocalAccountTokenFilterPolicy.ps1)
    - This script will remove a LocalAccountTokenFilterPolicy.  What this policy does is grant remote connections from all local members of the Administrators group full high-integrity tokens during negotiation.  After the PowerShellDSC deployment is complete, this policy should be removed as an additional security measure.

##### [createRemoveTrustedHosts folder](./3_settingUpServerEnvironment/dmz/internalServers/createRemoveTrustedHosts/)

- [**addTrustedHosts.ps1**](./3_settingUpServerEnvironment/dmz/internalServers/createRemoveTrustedHosts/addTrustedHosts.ps1)
    - This script will create a comma-separated string of IP addresses and hostnames for DMZ server(s) and sets the TrustedHosts configuration setting for WinRM on the internal server(s) passed as a list in the script.

- [**removeTrustedHosts.ps1**](./3_settingUpServerEnvironment/dmz/internalServers/createRemoveTrustedHosts/removeTrustedHosts.ps1)
    - This script will reset the TrustedHosts list, for each internal server passed in the script, back to its default value, which is an empty list.

### [forDisconnectedEnvironments folder](./3_settingUpServerEnvironment/forDisconnectedEnvironments)
<mark>These scripts can be used when the servers are disconnected from the internet, or if you're not planning on making use of the downloadSetups or download URL path parameters in the ArcGIS Module.</mark>

- [**transferInstallers.ps1**](./3_settingUpServerEnvironment/forDisconnectedEnvironments/transferInstallers.ps1)
    - this script will transfer the contents of an ‘installers’ folder (as well as any sub-directories) from a local location to a list of machines specified for each ArcGIS component. Make sure not to include the orchestrating machine in the list of $arcgisservers.

- [**transferPreRequisites.ps1**](./3_settingUpServerEnvironment/forDisconnectedEnvironments/transferPreRequisites.ps1)
    - This script transfers the Web Adaptor prerequisites from a local machine to the web server that will be used for hosting the Web Adaptors.

### [forMigrations folder](./3_settingUpServerEnvironment/forMigrations)
<mark>The scripts in this folder may be helpful for migrations and should be used as-desired and as-applicable.</mark>

- [**addHostEntry.ps1**](./3_settingUpServerEnvironment/forMigrations/addHostEntry.ps1)
    - This script adds a new host entry to the hosts file on multiple remote machines. It ensures that the specified DNS name resolves to the given IP address locally on each target machine. After adding the entry, the script verifies the DNS resolution to confirm it points to the correct IP address.  This script is useful for migrations involving PowerShellDSC, specifically while setting up the target environment for migration.

- [**removeHostEntry.ps1**](./3_settingUpServerEnvironment/forMigrations/removeHostEntry.ps1)
    - This script removes an existing host entry from the hosts file on multiple remote machines. After removing the entry, the script verifies the DNS resolution to ensure it points to the correct IP address according to the DNS server.  This script is useful for migrations involving PowerShellDSC, specifically post-migration after the migration has been completed successfully and the environment is ready for permanent DNS updates.

- [**setFirewallRulesBlockIpFilter.ps1**](./3_settingUpServerEnvironment/forMigrations/setFirewallRulesBlockIpFilter.ps1)
    - This script sets up a firewall rule on a list of specified machines to block inbound traffic from a list of specified IP addresses. It is intended to enhance security by preventing traffic from certain IP addresses in a specified environment.  This script is useful for migrations involving PowerShellDSC, specifically while setting up the target environment for migration to block unintended traffic to the new environment until its ready for use.

## [4_deployment folder](./4_deployment/)
<mark>These scripts should be used for invoking the deployment, choose one of the scripts below depending on the type of deployment.</mark>

- [**InvokeScript_Install.ps1**](./4_deployment/InvokeScript_Install.ps1)
    - This script starts the ArcGIS deployment in PowerShell. It first changes the directory to a path where logs can be accessed easily (such as within the folder structure where the rest of the deployment files are located). Then, it runs the Invoke-ArcGISConfiguration command with the configuration file. You can change the -Mode switch to one of the other options \[Install | InstallLicense | InstallLicenseConfigure | Uninstall | Upgrade | WebGISDRExport | WebGISDRImport\] to adjust to what you’d like the Invoke command to do.

- [**InvokeScript_Upgrade.ps1**](./4_deployment/InvokeScript_Upgrade.ps1)
    - This script starts the upgrade of the ArcGIS deployment in PowerShell. It first changes the directory to a path where logs can be accessed easily (such as within the folder structure where the rest of the deployment files are located). Then, it runs the Invoke-ArcGISConfiguration command with the configuration file. You can add all of the federated ArcGIS Servers' JSON files to this command as seen in the example in the code to upgrade the entire deployment in one command.

## [5_troubleshooting folder](./5_troubleshooting/)
<mark>The scripts in this folder can be used for troubleshooting issues with your PowerShell deployment and should be used as-needed.</mark>

- [**checkPortAvailablity.ps1**](./5_troubleshooting/checkPortAvailability.ps1)
    - This script does a few key things to assess network readiness for an ArcGIS Enterprise deployment.  First, it resolves a fully-qualified domain name into an IP address, which tests for DNS resolvability.  Then, it checks to see if the nmap tool is installed, and if not, the script will download and install it.  Finally, the script performs a port scan of the port you specify against the IP address which was resolved from the fully-qualified domain name you specified and reports on the state of the port reachability, without the need to have the ArcGIS Enterprise software installed and listening on the port.  This can be a helpful script to use before you begin a deployment to ensure that no firewalls or filters are blocking port traffic intended for the ArcGIS Enterprise application servers.

- [**restartServers.ps1**](./5_troubleshooting/restartServers.ps1)
    - This script remotely reboots servers provided in a list.  When troubleshooting an issue with your deployment, or if you encounter a situation where the PowerShell deploment fails and stalls mid-installation, it's sometimes helpful to reboot the server to clear out any pending actions/processes or settings.

- [**restartServices.ps1**](./5_troubleshooting/restartServices.ps1)
    - This script reports on the status of a Windows Service specified and then restarts it.  This may be helpful with general troubleshooting.

- [**stopServices.ps1**](./5_troubleshooting/stopServices.ps1)
    - This script remotely stops a Windows Service specified.  This may be helpful with general troubleshooting.

- [**taskKillWindowsInstaller.ps1**](./5_troubleshooting/taskKillWindowsInstaller.ps1)
    - This script remotely checks to see if the Windows Installer process is running, and if it is, it kills it.  Sometimes when a PowerShell deployment fails, it might fail during the installation of one of the ArcGIS components, leaving the installer process in a hung state.  If the Windows Installer process is not killed in these cases, any subsequent attempts to invoke the PowerShell command to install will also fail because the machine will assume another installation is still in progress.  So this script helps by checking to see if there is a hung installer process (ideally ran after a failure), and then removes the hung installer process if it exists to prepare the environment for the next invoke attempt.

### [forMigrations folder](./5_troubleshooting/forMigrations/)
<mark>The scripts in this folder may be helpful for migrations and should be used as-desired and as-applicable.</mark>

- [**checkForServiceMigrationIssues.ps1**](./5_troubleshooting/forMigrations/checkForServiceMigrationIssues.ps1)
    - This script is intended to be used for migrations that make use of PowerShell DSC.  After content is migrated between a source and target system, you can run this script targeting the ArcGIS Server logs to search for the string of text "Failed to create the service" to see if any services failed to migrate over.  If entries are found in the logs with a time stamp that is coincident with that of the migration attempt, you should investigate the /arcgisserver/config-store/services folder to see if the service is present.  If not, manually copy it from the source environment to the target environment.


## **How To Run These Scripts**
These scripts can be run by opening a Windows PowerShell ISE session as an Administrator, and then choosing the "Open Script" button (second from the left) from the toolbar.  The "Run" button runs the script and is located towards the middle of the same toolbar.  As a general note, you must "Save" a script before running it after making any changes, and you will be prompted to save if you do not do so before clicking "Run".