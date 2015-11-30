Param (
  [string]$from = $(throw "-from is required"),
  [string]$to = $(throw "-to is required")
)

# Then we are going to start fresh
netsh interface portproxy reset

# Iterate anything that can get out of localhost
$allIPs = get-WmiObject Win32_NetworkAdapterConfiguration | where-object {$_.DefaultIPGateway.length -eq 1} | foreach-object {$_.IPAddress}

foreach ($ip in $allIPs) {
	# This ip has default gateway
	write-host "IP Found: $ip"
	netsh interface portproxy add v4tov4 listenport=$from listenaddress=0.0.0.0 connectport=$to connectaddress=$ip
}

# Finally check the port
netstat -ano | findstr :$from
