# This script sets the firewall rules on the specified machines to allow inbound traffic on the specified ports.

# Define the list of machines to set the firewall rules on
$arcgisservers = @('machine1', 'machine2', 'machine3')
# Define the list of ports to allow
$ports = 80, 135, 443, 445, 6080, 6443, 7080, 7443, 2443, 9320, 9220, 21443, 29878, 29879, 45672, 45671, 29080, 29081, 9829, 20443, 20301

$parameters = @{
  ComputerName = $arcgisservers
  ScriptBlock = {
    param($ports)
    $ports | ForEach-Object {
      # Create a firewall rule to allow inbound traffic on the specified ports above
      New-NetFirewallRule -DisplayName "Allow ArcGIS Enterprise Ports In" -Direction Inbound -Action Allow -Protocol TCP -LocalPort $_
    }
  }
  ArgumentList = ($ports)
}

Invoke-Command @parameters
