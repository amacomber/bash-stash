Installer process for FortiClient vpn

1. Download FortiClient VPN.dmg for your FortiClient source
2. Mount FortiClient VPN.dmg

![ss-mounted_dmg](https://user-images.githubusercontent.com/68449783/182494001-bbc3aaca-850f-484a-b318-dcbb3b999728.png)

3. Open Packages.app and create a structure as follows into a .pkg
<img width="853" alt="ss-pkg_contents" src="https://user-images.githubusercontent.com/68449783/182494027-a6e3ec8d-4bdc-467f-904c-c90b6e84bcbf.png">
4. Upload FortiClient.pkg to your Jamf Pro (or other) server
5. Upload forticlient.sh to your Jamf Pro (or other) server
6. Upload Forticlient.mobileconfig to your Jamf Pro (or other) server
7. Build a policy that runs the .pkg first (this will put all the files into the right place)
8. Have the policy run the forticlient.sh afterwards to install the files
