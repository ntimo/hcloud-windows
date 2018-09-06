# hcloud-windows
This .sh scripts starts a Windows server in the Hetzner.com cloud from a snapshot.

The script will start your Windows server from a snapshot, update the dynDNS in case the IP changes and then when you want to stop it create a new snapshot and delte the server.

## Requierments
1. A Hetzner.com account

## Setup
1. you need to install the hcloud cli this can be done with:
brew install hcloud
2. After that you will need to have add a context called WindowsDesktop this can be done with:
hcloud context create WindowsDesktop
3. You need to configure your Dynv6 credentials in the script.
4. You need to have a already installed Windows Server in your Hetzner Cloud project called Windows


## Help menu:
 start    - to recreate the server from snapshot and start it.<br>
 stop     - to stop the server and delte it after creating a snapshot.<br>
 snapshot - to create a snapshot.<br>
 status   - to see server status.<br>
 ip       - to show the server IP<br>
 updateip - to update the DynDNS IP<br>


Have fun.


Special thanks to [Knight1](https://github.com/knight1) for the original script.
