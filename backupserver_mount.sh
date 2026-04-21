#!/bin/bash
# ==============================================================================
# Script:      backupserver_mount.sh
# Description: Automatically detects location via IP subnet and mounts the correct backup server.
# Author:      Ralf R. (ralf.rangedahl@alina.se)
# Version:     2.0.3
# Date:        2026-04-21
# ==============================================================================

source /usr/local/bin/alina-env.sh

# ==========================================
# INITIALIZATION
# ==========================================
alina_header "🌐 BACKUP SERVER AUTO-MOUNT"

# 1. LIVE CD FIX: Ensure the mount directory actually exists!
echo -e "${YELLOW}Ensuring mount directory exists (/mnt/backupserver)...${NC}"
mkdir -p /mnt/backupserver

# 2. LIVE CD FIX: Wait for the network to actually assign an IP.
echo -e "${YELLOW}Waiting for network to assign an IP address...${NC}"

# This loops every 2 seconds until it finds an IP that is NOT the local loopback (127.x.x.x)
ipmatch=""
while [[ -z "$ipmatch" || "$ipmatch" == "127.0.0" ]]; do
  sleep 2
  ipmatch=$(awk '/32 host/ {print f} {f=$2}' <<< "$(</proc/net/fib_trie)" | grep -v "127.0.0.1" | cut -f1-3 -d. | sed -n '1p')
done

echo -e "${GREEN}✅ Network connected! Detected subnet:${NC} $ipmatch.x"
echo -e "${CYAN}--------------------------------------------------${NC}"

# Server Array. 10.110=KH, 10.120=ENK, 10.130=NK, 10.140=Öst 10.130.3=NK admin
SERVERS=(
  10.110.20.10
  10.120.20.80
  10.130.20.210
  10.140.20.201
  10.130.3.210
)  

echo -e "${YELLOW}Searching for a matching local backup server...${NC}"
MOUNTED=false
    
# Loop through the array and mount the matching server
for ((i =0; i < ${#SERVERS[@]}; i++))
do
  if [[ $(echo "${SERVERS[$i]}" | cut -f1-3 -d.) == "$ipmatch" ]]; then
    echo -e "${WHITE}Match found! Connecting to Server:${NC} ${SERVERS[$i]}"
    
    # Matches! Mount the drive and give alina (uid 1000) full access
    if mount -t cifs //${SERVERS[$i]}/backup /mnt/backupserver -o username=backup,password=backup,iocharset=utf8,uid=1000,gid=1000; then
        echo -e "${GREEN}✅ Successfully mounted //${SERVERS[$i]}/backup to /mnt/backupserver!${NC}"
        MOUNTED=true
    else
        echo -e "${RED}❌ Failed to mount server ${SERVERS[$i]}! Check permissions or network.${NC}"
    fi
    
    # Exit the loop since we successfully found and processed our server
    break 
  fi
done

if [ "$MOUNTED" = false ]; then
    echo -e "\n${RED}❌ No matching server found for this subnet, or mount failed.${NC}"
fi

echo -e "${CYAN}==================================================${NC}"
# ==============================================================================
# EOF - End of script
# ==============================================================================