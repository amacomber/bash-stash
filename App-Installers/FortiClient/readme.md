Installer process for FortiClient vpn

1. Download FortiClient VPN.dmg for your FortiClient source
2. Mount FortiClient VPN.dmg

3. Open Packages.app and create a structure as follows into a .pkg
4. Upload FortiClient.pkg to your Jamf Pro (or other) server
5. Upload forticlient.sh to your Jamf Pro (or other) server
6. Upload Forticlient.mobileconfig to your Jamf Pro (or other) server
7. Build a policy that runs the .pkg first (this will put all the files into the right place)
8. Have the policy run the forticlient.sh afterwards to install the files
