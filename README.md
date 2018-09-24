# hcloud-windows
This bash script starts a Windows server in the Hetzner Cloud from a snapshot.

The script will start your Windows server from a snapshot, update the dynDNS, when the IP changes. When you decided to stop the server, the script creates a new snapshot and deletes the server.

## Requierments
1. A hetzner.com account

## Setup
1. you need to install the hcloud cli this can be done with:
`brew install hcloud`
2. After that you will need to have add a context called WindowsDesktop this can be done with:
`hcloud context create WindowsDesktop`
3. You need to configure your Dynv6 credentials in the script.
4. You need to have a already installed Windows Server in your Hetzner Cloud project called `Windows`


## Help menu:
 `start`    - to recreate the server from snapshot and start it.<br>
 `stop`     - to stop the server and delte it after creating a snapshot.<br>
 `snapshot` - to create a snapshot.<br>
 `status`   - to see server status.<br>
 `ip`       - to show the server IP<br>
 `updateip` - to update the DynDNS IP<br>


Have fun.


Special thanks to [Knight1](https://github.com/knight1) for the original script.
