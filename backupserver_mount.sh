#!/bin/bash -x

# Script to mount the backupserver based on location.

# 1. LIVE CD FIX: Ensure the mount directory actually exists!
# mkdir -p /mnt/backupserver

# 2. LIVE CD FIX: Wait for the network to actually assign an IP.
# This loops every 2 seconds until it finds an IP that is NOT the local loopback (127.x.x.x)
ipmatch=""
while [[ -z "$ipmatch" || "$ipmatch" == "127.0.0" ]]; do
  sleep 2
  ipmatch=$(awk '/32 host/ {print f} {f=$2}' <<< "$(</proc/net/fib_trie)" | grep -v "127.0.0.1" | cut -f1-3 -d. | sed -n '1p')
done

# Server Array. 10.110=KH, 10.120=ENK, 10.130=NK, 10.140=Öst 10.130.3=NK admin
SERVERS=(
  10.110.20.10
  10.120.20.80
  10.130.20.210
  10.140.20.201
  10.130.3.210
)  
    
# Loop through the array and mount the matching server
for ((i =0; i < ${#SERVERS[@]}; i++))
do
  if [[ $(echo ${SERVERS[$i]} | cut -f1-3 -d.) == $ipmatch ]]; then
    # Matches! Mount the drive and give alina (uid 1000) full access
    mount -t cifs //${SERVERS[$i]}/backup /mnt/backupserver -o username=backup,password=backup,iocharset=utf8,uid=1000,gid=1000
    # Exit the loop since we successfully found and mounted our server
    break 
  fi
done
