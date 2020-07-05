#!/bin/bash

# This function will start our JSON text.
startJSON() {
  echo '{'
  echo '  "service" : ['
}

# This function will return a single block of JSON for a single service.
exportService() {
  echo '  {'
  echo '    "name":"'$1'",'
  echo '    "ipaddress":"'${ip}'",'
  echo '    "macaddress":"'${mac}'"'
  echo '  }'
}

# This function will finish our JSON text.
endJSON() {
  echo '  ]'
  echo '}'
}

# get Ethernet information.
eip=$(networksetup -getinfo ethernet | grep -Ei '(^IP address:)' | awk '{print $3}')
emac=$(networksetup -getinfo ethernet | grep -Ei '(^Ethernet address:)' | awk '{print $3}')
if [ "$eip" = "" ];then
    if networksetup -listallnetworkservices | grep -qEi '^Display Ethernet'; then
        service="Display Ethernet"
    else
        service="Thunderbolt Ethernet"
    fi

    eip=$(networksetup -getinfo "$service" | grep -Ei '(^IP address:)' | awk '{print $3}')
    emac=$(networksetup -getinfo "$service" | grep -Ei '(^Ethernet address:)' | awk '{print $3}')
fi

# get the Wi-Fi information.
wip=$(networksetup -getinfo wi-fi | grep -Ei '(^IP address:)' | awk '{print $3}')
wmac=$(networksetup -getinfo wi-fi | grep -Ei '(^Wi-Fi ID:)' | awk '{print $3}')

# get the VPN information
vip=$(ifconfig ipsec0 | grep inet | awk '{print $2}')
vmac=""

# Start the JSON.
startJSON

# Output the Ethernet information.
ip=$eip
mac=$emac
exportService "ethernet"

# Place a comma between services.
echo '  ,'

# Output the Wi-Fi information.
ip=$wip
mac=$wmac
exportService "wi-fi"

echo ' ,'

# Output the VPN information
ip=$vip
mac=$vmac
exportService "vpn"

# End the JSON
endJSON
