#!/bin/bash
iOSAddr=192.168.0.201
pkgId=$(cat control | grep Package | cut -d ':' -f 2 | cut -c 2-)

echo "iOSAddr => ${iOSAddr}"
echo "pkgId => ${pkgId}"

echo "Cleaning previous make stuff..."
make clean

echo "Creating new package..."
buildLog=$(make package FINALPACKAGE=1)
fileName=$(echo "$buildLog" | grep -o 'packages/.*\.deb' | head -n 1)
strippedFileName=$(basename "${fileName}")

echo "fileName => ${fileName}"
echo "strippedFileName => ${strippedFileName}"

echo "Sending package to ${iOSAddr}..."
scp "${fileName}" mobile@${iOSAddr}:/var/jb/var/mobile/${strippedFileName}

echo "Installing new package natively over rootless bootstrap..."
# On rootless, mobile can install to /var/jb directly without sudo!
ssh mobile@${iOSAddr} "echo alpine | sudo -S dpkg -i /var/jb/var/mobile/${strippedFileName}"

echo "Refreshing UI cache..."
# Essential for iOS to discover the new app inside /var/jb/Applications/
ssh mobile@${iOSAddr} "uicache -p /var/jb/Applications/HackTool.app"

echo "Launching ${pkgId}..."
ssh mobile@${iOSAddr} "open ${pkgId}"
