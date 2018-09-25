# hcloud-windows

[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-orange.svg)](https://github.com/ntimo/hcloud-windows/pulls)

This bash script starts a Windows server, client or Linux Machine in the [Hetzner Cloud](https://www.hetzner.com/cloud) from a snapshot. So you only pay for the snapshot (0,0119€ per GB) if you don't need the machine it. And you only pay for the space the snapshot needs. So if you use 2GB you only pay for that 2GB. If you need 32GB RAM, 8 vCores you power it up and only pay on an hourly basis.

The script will let you start your Windows or Linux machine from a snapshot, update the [dynv6.com](https://dynv6.com/) IP, when the IP changes, manages snapshots, . When you decided to stop the server, the script creates a new snapshot and deletes the server. So you only pay for the used resources in an hourly manner.

## Requirements
1. A [hetzner.com](hetzner.com) account with valid address and payment information. You may be asked for your identity because it is postpaid. If they may skip it or please redact everything which is not absolutly needed like serialnumbers, face, issuing date, signature, hight, eye collor, etc.


## Setup client
1. You need to install the hcloud cli. This can be done with:
   - macOS with installed [Homebrew](https://brew.sh) via `brew install hcloud`
   - pre-built binaries for Linux, FreeBSD, macOS, and Windows via [hcloud cli GitHub Releases](https://github.com/hetznercloud/cli/releases)
2. After that you need to have a context (Hetzner Cloud Project Name) called *WindowsDesktop* this can be done with:
`hcloud context create WindowsDesktop`. You can change that behavior via changing the *PROJECTNAME* variable inside the script.
3. The default Servername the script expects is *Windows*. If you want to change that simply change *SERVERNAME* inside the script.
4. If you don't know how to do that visit [Hetzner Wiki](https://wiki.hetzner.de/index.php/Windows_on_Cloud/en)
5. You MAY configure your [dynv6.com](https://dynv6.com/) credentials in the script.

## Setup machine
1. Install the Windows Server, Client or Linux Machine. If you want a Windows client you need to send the ISO to Hetzner via Support Ticket.
2. Setup the machine so that it starts without manual intervention. Windows Client and Windows Server need at least 4GB RAM so minimum is CX21. If you want to encrypt it keep in mind that you need to setup Dropbear under Linux and unter Windows you need to open the HTML5 console.
3. Set up RDP, SSH, [TeamViewer](https://teamviewer.com), [AnyDesk](https://anydesk.com), etc..
   - SSH: If you use default Hetzner Cloud configuration you get the password via email. If you want to use SSH keys upload it inside the project. Keep in mind that the default configuration allows password Login and uses default port.
   - RDP Windows Client: Start, Control Panel, System, Advanced system settings, Remote -> Allow Remote Assistance connections to this computer.
   - RDP Windows Server 2016: Start, Server Manager, Local Server, Remote Desktop -> Allow remote connections to this computer.
   Don's use default Administrator, use a good password, maybe you change the RDP Port.
4. Set everything up how you like it.
5. Star it, contribute, have fun!

## Links
### RDP Microsoft
[iOS](https://itunes.apple.com/de/app/microsoft-remotedesktop/id714464092?mt=8)
[macOS](https://itunes.apple.com/de/app/microsoft-remote-desktop-10/id1295203466?mt=12)
[Android](https://play.google.com/store/apps/details?id=com.microsoft.rdc.android&hl=de)
[Windows Phone, HoloLens, Windows, Hub](https://www.microsoft.com/de-de/p/microsoft-remotedesktop/9wzdncrfj3ps)

### RDP other
[ChromeOS](https://chrome.google.com/webstore/detail/chrome-rdp/cbkkbcmdlboombapidmoeolnmdacpkch)


## Further
- This script currently ***ONLY SUPPORTS ONE SERVER*** per context (Project)!
- If you change the Servername while the server is running. You guessed it, you broke it :P
- Move the script to a location (For example /usr/local/bin), where you can execute it without changing directories.
- In case you use the system not that often keep an eye on apt update and Windows Updates.
- Keep in mind that Hetzner will tell you that this is not allowed.
- Keep also in mind that you need to license the Windows machine so that it stays up to date. Use your own license or Google will help you.
- Space is limited. If you upgrade your instance with storage you pay more :o So update only CPU and RAM NOT! Storage so you get more power if you need. If you need more Storage you can mount for Example the Hetzner storage Box, Dropbox, Mega, Google Drive. Your Internet Speed is around 4 Gbit/s so don't worry. Your files are sync within a blink.
- Starting the new server with a smaller disc then the snapshot contains may void your WARRANTY. You don't have one so don't do it! :) The Partition is still XGB big but the server only has yGB. If the filesystem thinks writing into that sector is a sweet idea bad things will happen.

## Setup $PATH
Insert `export PATH="/path/:$PATH"` into your .bashrc File inside your Home Directory with the text editor you like. If you use macOS the file is called .bash_profile
Execute `source ~/.bashrc`

Now you can execute windows.sh everywhere. If not check if you can execute it inside the folder, if not execute `chmod u+x windows.sh`

## You want to contribute? [![Awesome Badges](https://img.shields.io/badge/badges-awesome-green.svg)](https://github.com/Naereen/badges)

Issues, Pull Requests and Wiki additions are very welcome 😊

## Commands
```text
 start    - to recreate the server from snapshot and start it.
 stop     - to stop the server and delte it after creating a snapshot.
 snapshot - to create a snapshot.
 status   - to see server status.
 ip       - to show the server IP
 updateip - to update the dynv6.com IP
```

Have fun!


Special thanks to [Knight1](https://github.com/knight1) for the original script.
