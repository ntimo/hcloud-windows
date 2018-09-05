#!/bin/bash
#set -x

STATUS=`hcloud server list | tail -1 | grep Windows | awk '{print $3;}'`
ID=`hcloud server list | tail -1 | grep Windows | awk '{print $1;}'`
SSHKEY=`hcloud ssh-key list | tail -1 | awk '{print $1;}'`
IPV4=`hcloud server list | tail -1 | grep Windows | awk '{print $4;}'`

CONTEXT=`hcloud context active`
# Display name of the server how its named in your Hetzner project.
DISPLAYNAME='Windows'

# DNS settings
# You need to have a dynv6.net DynDNS adress if you want to use this script please edit your details below
hostname='please-edit.dynv6.net'
token='yourtoken'

if [ "$CONTEXT" != "WindowsDesktop" ]; then
  echo "[CRIT] Aborting, wrong context"
  exit
fi

# stop, force stop, snapshot, delete
delete() {
  if [ "$STATUS" == "" ]; then
    echo "Server does not exit, to start it use ./windows.sh start"
    exit
  fi

  echo "Shuting down server"

  hcloud server shutdown $DISPLAYNAME
  if [ "$?" != "0" ]; then
    sleep 60
    hcloud server poweroff $DISPLAYNAME
  fi

  echo "creating snapshot..."
  hcloud server create-image $DISPLAYNAME --type snapshot --description `date '+Windows-%Y-%m-%d_%H-%M'` || echo "[CRIT] Snapshot error" | exit 1

  hcloud server delete $DISPLAYNAME
  curl -fsS "https://ipv4.dynv6.com/api/update?hostname=$hostname&ipv4=127.0.0.1&token=$token"
}

# create snapshot
make_snapshot() {
  if [ "$STATUS" == "" ]; then
    echo "Server does not exit, to start it use ./windows.sh start"
    exit
  fi
  hcloud server create-image $DISPLAYNAME --type snapshot --description `date '+Windows-%Y-%m-%d_%H-%M'` || echo "[CRIT] Snapshot error" | exit 1
}

# create from snapshot, update DNS
create() {
  if [ "$2" == "latest" ]; then
    hcloud image list | grep snapshot | grep Windows
    read  -n 1 -p "Select Snapshot ID:" SNAPID
  else
    SNAPID=`hcloud image list | grep snapshot | grep Windows | tail -1 | awk '{print $1;}'`
  fi

  if [ "$SNAPID" == "" ]; then
    exit 1
  fi
hcloud server create --datacenter 2 --image $SNAPID --name $DISPLAYNAME --type 5 --ssh-key $SSHKEY
sleep 1
IPV4NEW=`hcloud server list | tail -1 | grep Windows | awk '{print $4;}'`
sleep 1
curl -fsS "https://ipv4.dynv6.com/api/update?hostname=$hostname&ipv4=$IPV4NEW&token=$token"

}

# check server status
status() {
if [ "$STATUS" == "" ]; then
  echo "Server does not exit to start it use ./windows.sh start"
else
echo "Server is" $STATUS.
fi
}

# check server IP
ip() {
if [ "$IPV4" == "" ]; then
  echo "Server does not exit, to start it use ./windows.sh start"
else
echo "Server IPV4 adress is" $IPV4.
fi
}

# update IP DynDNS
updateip() {
  if [ "$IPV4" == "" ]; then
    echo "Server does not exit, to start it use ./windows.sh start"
  else
  curl -fsS "https://ipv4.dynv6.com/api/update?hostname=$hostname&ipv4=$IPV4&token=$token"
  echo "Updated server $hostname DynDNS IP."
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
    echo "Nothing selected"
    help
    exit
    ;;
esac
