# hcloud-windows

[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-orange.svg)](https://github.com/ntimo/hcloud-windows/pulls)

This bash script starts a Windows server, client or Linux Machine in the Hetzner Cloud from a snapshot. So you only pay for the snapshot (0,01€ per GB) if you don't use it. If you need 32GB RAM, 8 vCores you power it up and only pay on an hourly basis.

The script will let you start your Windows or Linux machine from a snapshot, update the (dynv6.com)[https://dynv6.com/] IP, when the IP changes, manages snapshots, . When you decided to stop the server, the script creates a new snapshot and deletes the server. So you only pay for the used resources in an hourly manner.

## Requirements
1. A hetzner.com account


## Setup client
1. You need to install the hcloud cli this can be done with:
  - macOS with installed (Homebrew)[https://brew.sh] `brew install hcloud`
  - pre-built binaries for Linux, FreeBSD, macOS, and Windows https://github.com/hetznercloud/cli/releases
2. After that you will need to have add a context called WindowsDesktop this can be done with: `hcloud context create WindowsDesktop`. You can change that via changing the PROJECTNAME variable.
3. You may configure your (dynv6.com)[https://dynv6.com/] credentials in the script.
4. You need to have an already installed Windows Machine in your Hetzner Cloud project called `Windows`. Otherwise change the variable SERVERNAME

## Setup machine
1. Install the Windows Server, Client or Linux Machine. If you want a Windows client you need to send the ISO to Hetzner via Support Ticket.
2. Setup the machine so that it starts without manual intervention. Windows Client and Windows Server need at least 4GB RAM so minimum is CX21. If you want to encrypt it keep in mind that you need to setup Dropbear under Linux and unter Windows you need to open the HTML5 console.
3. Set everything up how you like it.
4. Star it, contribute, have fun!

## Further
- Move the script to a location (For example /usr/local/bin), where you can execute it without changing directories.
- In case you use the system not that often keep an eye on apt update and Windows Updates.
- Keep in mind that Hetzner will tell you that this is not allowd.
- Keep also in mind that you need to license the Windows machine so that it stays up to date. Use your own license or Google will help you.
- Space is limited. If you upgrade your instance with storage you pay more :o So update only CPU and RAM NOT! Storage so you get more power if you need. If you need more Storage you can mount for Example the Hetzner storage Box, Dropbox, Mega, Google Drive. Your Internet Speed is around 4 Gbit/s so don't worry. Your files are sync within a blink.

## Setup $PATH
Insert `export PATH="/path/:$PATH"` into your .bashrc File inside your Home Directory with the text editor you like. If you use macOS the file is called .bash_profile
Execute `source ~/.bashrc`

Now you can execute windows.sh everywhere. If not check if you can execute it inside the folder, if not execute `chmod u+x windows.sh`

## You want to contribute? [![Awesome Badges](https://img.shields.io/badge/badges-awesome-green.svg)](https://github.com/Naereen/badges)

Issues, Pull Requests and Wiki additions are very welcome 😊

## Help menu:
 `start`    - to recreate the server from snapshot and start it.<br>
 `stop`     - to stop the server and delte it after creating a snapshot.<br>
 `snapshot` - to create a snapshot.<br>
 `status`   - to see server status.<br>
 `ip`       - to show the server IP<br>
 `updateip` - to update the DynDNS IP<br>

Have fun!


Special thanks to [Knight1](https://github.com/knight1) for the original script.
