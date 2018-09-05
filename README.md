# hcloud-windows
This .sh scripts starts a Windows server in the Hetzner.de cloud from a snapshot.

The script will start your Windows server from a snapshot, update the dynDNS in case the IP changes and then when you want to stop it create a new snapshot and delte the server.

## Setup
1. you need to install the hcloud cli this can be done with:
brew install hcloud
2. After that you will need to have add a context called WindowsDesktop this can be done with:
hcloud context create WindowsDesktop
3. You need to configure your Dynv6 credentials in the script.
4. You need to have a already installed Windows Server in your Hetzner Cloud project called Windows


## Help menu:
 start    - to recreate the server from snapshot and start it.
 stop     - to stop the server and delte it after creating a snapshot.
 snapshot - to create a snapshot.
 status   - to see server status.
 ip       - to show the server IP
 updateip - to update the DynDNS IP
Have fun.

