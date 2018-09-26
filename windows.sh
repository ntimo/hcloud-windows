#!/bin/bash
#set -x

### SETTINGS ###

# Display name of the server how its named in your Hetzner project.
SERVERNAME='Windows'
PROJECTNAME='WindowsDesktop'
DATACENTER='nbg1-dc3' #hcloud datacenter list
SERVERTYPE='cx31' #hcloud server-type list

# DNS settings
# You need to have a dynv6.net DynDNS address if you want to use this feature
HOSTNAME='please-edit.dynv6.net' #Hostname
TOKEN='' #Enter Token from dynv6.net

### END OF SETTINGS ###

if [ -f env_override.conf ]; then
    source env_override.conf
fi

if ! ping -q -c 1 api.hetzner.cloud > /dev/null; then echo "[FATAL] Unable to ping Hetzner API! Without Internet we can't do anything for you :o" | exit 1; fi

ID=$(hcloud server list | tail -1 | grep "$SERVERNAME" | awk '{print $1;}')

STATUS=$(hcloud server list | tail -1 | grep "$SERVERNAME" | awk '{print $3;}')
IPV4=$(hcloud server list | tail -1 | grep "$SERVERNAME" | awk '{print $4;}')
SSHKEY=$(hcloud ssh-key list | tail -1 | awk '{print $1;}')
CONTEXT=$(hcloud context active)

#Check context (Project)
if [ "$CONTEXT" != "$PROJECTNAME" ]; then
  echo "[CRIT] Aborting, wrong active Hetzner cloud context"
  echo "To see all available context's (Projects) enter hcloud context list"
  echo "To change the active context to the defined one within this script enter hcloud context use \"$PROJECTNAME\""
  exit 1
fi

# stop, force stop, snapshot, delete
delete() {
  status
  shutdown
  make_snapshot

  echo "Deleting Server \"$ID\""
  exec "hcloud server delete $SERVERNAME" 10 5 "deleting server"
  IPV4="127.0.0.1" #Overwrite IP, server is gone
  updateip
}

# create snapshot
make_snapshot() {
  status
  echo "Creating snapshot..."
  exec "hcloud server create-image --type snapshot --description \"$(date '+'$SERVERNAME'-%Y-%m-%d_%H-%M')\" $SERVERNAME" 10 5 "snapshot creation"
}

shutdown() {
  echo "Shuting down server"
  if ! hcloud server shutdown $SERVERNAME
  then
    echo "ACPI (power button Press) timeout. We now wait 180 seconds then we switch off the power."
    echo "If you don't want that press Ctrl-C, save everything, shut it down and repeat the script."
    echo "Please make sure that there is no update installing right now!"
    sleep 180
    hcloud server poweroff $SERVERNAME
  fi

}

exec () {
  #COMMAND, TRYCOUNTER, SLEEP, OPERATION
    COMMAND=$1
    TRYCOUNTER=$2
    SLEEPCOUNTER=$3
    OPERATION=$4

    for i in $(seq 1 $TRYCOUNTER)
    do
      if ! command $COMMAND
      then
        echo "[CRIT] \"$OPERATION\" failed!"
        if ! ping -q -c 1 api.hetzner.cloud > /dev/null; then echo "[CRIT] Unable to ping Hetzner API!"; fi
        if [ "$i" != "$TRYCOUNTER" ]; then
          echo "I will keep trying it \"$TRYCOUNTER\" Times with a \"$SLEEPCOUNTER\" second pause."
          sleep $SLEEPCOUNTER
        fi
      else
        return
      fi
    done
  echo "[FATAL ERROR] ABORTING! I AM SO SORRY. I was not able to recover from this bad situation."
  echo "[FATAL ERROR] Please check status.hetzner.com, check if you can visit api.hetzner.com, if the operation is still in progress or may finished or retry. Server remains AS IS."
  echo "[FATAL ERROR] You can try to create the snapshot (Name it ) by yourself, and delete the server within the Webinterface."
  echo "[FATAL ERROR] You ask for help via Issue, contact us on social media or contact Hetzner (Not for Script Bugs :o)."
  exit 1
}

# create from snapshot, update DNS
create() {
  if [ "$2" != "latest" ]; then
    hcloud image list | grep snapshot | grep $SERVERNAME
    read -n 1 -p -r "Select Snapshot ID: \"$SNAPID\""
  else
    SNAPID=$(hcloud image list | grep snapshot | grep "$SERVERNAME" | tail -1 | awk '{print $1;}')
  fi

  if [ "$SNAPID" == "" ]; then
    echo "Sorry I was not able to fetch any Snapshot. Execute hcloud image list for a list."
    exit 1
  fi

  if [ "$SSHKEY" == "" ]; then
    SSHKEY="--ssh-key $SSHKEY"
    echo "We recommend you setting up an ssh key so you won't get any emails everytime you create a new Windows server and ofcourse better security."
  fi
    exec "hcloud server create --datacenter "$DATACENTER" --image "$SNAPID" --name "$SERVERNAME" --type "$SERVERTYPE" "$SSHKEY"" 10 5 "creating server"
    updateip
}

# check server status
status() {
  if [ "$STATUS" == "" ]; then
    echo "Server does not exist! To start/create it use ./windows.sh start"
  else
    echo "Server is \"$STATUS\""
  fi
}

# check server IP
ip() {
  if [ "$IPV4" == "" ]; then
    echo "Server does not exist, to start it use ./windows.sh start"
  else
    echo "Server IPv4 adress is \$IPV4\""
  fi
}

# update IP DynDNS
updateip() {
  #Don't display this message after server creation
  if [ "$TOKEN" != "" ] && [ "$IPV4" != "127.0.0.1" ]; then
    echo "You expect that I can update your dynv6.com IP without credentials like Harry Potter? Sorry I can't do that for you :("
    exit 1
  elif [ "$IPV4" == "" ]; then
    echo "Server does not exist, to start it use ./windows.sh start"
  else
    curl -fsS "https://ipv4.dynv6.com/api/update?hostname=$HOSTNAME&ipv4=$IPV4&token=$TOKEN"
    echo "Updated server \"$HOSTNAME\" dynv6.com IP to \"$IPV4\""
    echo "You can now connect :)"
  fi
}

updatehosts() {
  OS=$(uname)
  #Do we need Windows? :D
  case $OS in
    'Linux')
      HOSTS="/etc/hosts"
    ;;
    'WindowsNT')
      HOSTS="/etc/hosts"
    ;;
    'Darwin')
      HOSTS="/etc/hosts"
    ;;
    *)
    echo "Unknown Operating System :o"
    ;;
esac
  if [ $(< $HOSTS grep hetznercloud) != "" ]
  then
    #Update
    sudo sed -i 's/hetznercloud/c\\"$IP\" hetznercloud' $HOSTS #Broken
  else
    #Insert
    sudo echo "$IP hetznercloud" | sudo tee -a $HOSTS
  fi
}


# help menu
help() {
echo "Help menu:

 start    - to recreate the server from snapshot and start it.
 stop     - to stop the server and delte it after creating a snapshot.
 shutdown - Shutdown the server.
 snapshot - to create a snapshot.
 status   - to see server status.
 ip       - to show the server IP
 updateip - to update the DynDNS IP"
}

echo "$1"

case "$1" in
start)
    create
    ;;
stop)
    delete
    ;;
snapshot)
    make_snapshot
    ;;
status)
    status
    ;;
help)
    help
    ;;
ip)
    ip
    ;;
updateip)
    updateip
    ;;
*)
    echo "Nothing selected :o"
    help
    exit
    ;;
esac
