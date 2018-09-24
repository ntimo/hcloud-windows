#!/bin/bash
#set -x

### SETTINGS

# Display name of the server how its named in your Hetzner project.
SERVERNAME='Windows'
PROJECTNAME='WindowsDesktop'

# DNS settings
# You need to have a dynv6.net DynDNS adress if you want to use this script please edit your details below
HOSTNAME='please-edit.dynv6.net'
TOKEN='' #Enter Token from dynv6.net

### END OF SETTINGS

STATUS=$(hcloud server list | tail -1 | grep "$SERVERNAME" | awk '{print $3;}')
ID=$(hcloud server list | tail -1 | grep "$SERVERNAME" | awk '{print $1;}')
IPV4=$(hcloud server list | tail -1 | grep "$SERVERNAME" | awk '{print $4;}')
SSHKEY=$(hcloud ssh-key list | tail -1 | awk '{print $1;}')
CONTEXT=$(hcloud context active)

if [ "$CONTEXT" != "$PROJECTNAME" ]; then
  echo "[CRIT] Aborting, wrong active Hetzner cloud context"
  echo "To see all available context's (Projects) enter hcloud context list"
  echo "To change the active context to the defined one within this script enter hcloud context use \"$PROJECTNAME\""
  exit
fi

# stop, force stop, snapshot, delete
delete() {
  if [ "$STATUS" == "" ]; then
    echo "Server does not exist, to start it use ./windows.sh start"
    exit
  fi

  echo "Shuting down server"
  if ! hcloud server shutdown $SERVERNAME
  then
    echo "ACPI (button Press) timeout. We now wait 60 seconds then we switch off the power."
    echo "If you don't want that press Ctrl-C, save everything, shut it down and repeat the script."
    sleep 60
    hcloud server poweroff $SERVERNAME
  fi

  echo "creating snapshot..."
  hcloud server create-image $SERVERNAME --type snapshot --description "$(date '+Windows-%Y-%m-%d_%H-%M')" || echo "[CRIT] Snapshot error" | exit 1

  echo "deleting Server \"$ID\""
  hcloud server delete $SERVERNAME
  if [[ "$TOKEN" != "" ]]; then curl -fsS "https://ipv4.dynv6.com/api/update?hostname=$HOSTNAME&ipv4=127.0.0.1&token=$TOKEN"; fi
}

# create snapshot
make_snapshot() {
  if [ "$STATUS" == "" ]; then
    echo "Server does not exit, to start it use ./windows.sh start"
    exit
  fi
  hcloud server create-image $SERVERNAME --type snapshot --description "$(date '+Windows-%Y-%m-%d_%H-%M')" || echo "[CRIT] Snapshot error" | exit 1
}

# create from snapshot, update DNS
create() {
  if [ "$2" == "latest" ]; then
    hcloud image list | grep snapshot | grep $SERVERNAME
    read -n 1 -p -r "Select Snapshot ID: \"$SNAPID\""
  else
    SNAPID=$(hcloud image list | grep snapshot | grep "$SERVERNAME" | tail -1 | awk '{print $1;}')
  fi

  if [ "$SNAPID" == "" ]; then
    exit 1
  fi

    if [ "$SSHKEY" == "" ]; then
      hcloud server create --datacenter 2 --image "$SNAPID" --name "$SERVERNAME" --type 5
    else
      hcloud server create --datacenter 2 --image "$SNAPID" --name "$SERVERNAME" --type 5 --ssh-key "$SSHKEY"
    fi
  sleep 0.1
  IPV4=$(hcloud server list | tail -1 | grep "$SERVERNAME" | awk '{print $4;}')
  sleep 0.1
  if [[ "$TOKEN" != "" ]]; then curl -fsS "https://ipv4.dynv6.com/api/update?hostname=$HOSTNAME&ipv4=$IPV4&token=$TOKEN"; fi
}

# check server status
status() {
  if [ "$STATUS" == "" ]; then
    echo "Server does not exist to start it use ./windows.sh start"
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
  if [ "$TOKEN" != "" ]; then
    echo "You expect that I can update your dynDNS IP without credentials like Harry Potter? Sorry I can't do that for you :("
    exit 1
  elif [ "$IPV4" == "" ]; then
    echo "Server does not exist, to start it use ./windows.sh start"
  else
    curl -fsS "https://ipv4.dynv6.com/api/update?hostname=$HOSTNAME&ipv4=$IPV4&token=$TOKEN"
    echo "Updated server \"$HOSTNAME\" dynv6.com IP to \"$IPV4\""
  fi
}

# help menu
help() {
echo "Help menu:

 start    - to recreate the server from snapshot and start it.
 stop     - to stop the server and delte it after creating a snapshot.
 snapshot - to create a snapshot.
 status   - to see server status.
 ip       - to show the server IP
 updateip - to update the DynDNS IP"
}

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
