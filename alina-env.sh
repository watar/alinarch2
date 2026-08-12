#!/bin/bash
# ==============================================================================
# Script:      alina-env.sh
# Description: Global environment variables and standard functions for Alina Arch.
# Author:      Ralf R. (ralf.rangedahl@alina.se)
# Version:     2.1.11
# Date:        2026-08-11
# ==============================================================================

# 1. UNIFIED COLOR PALETTE
export RED='\e[1;31m'
export GREEN='\e[1;32m'
export CYAN='\e[1;36m'
export WHITE='\e[1;37m'
export YELLOW='\e[1;33m'
export NC='\e[0m'

# 2. STANDARD HEADER FUNCTION
alina_header() {
    local tool_name="$1"
    clear
    echo -e "${CYAN}==================================================${NC}"
    echo -e "${WHITE} $tool_name ${NC}"
    echo -e "${CYAN}==================================================${NC}"
}

# 3. SERVER CONNECTION CHECK FUNCTION
check_mount() {
    if ! mountpoint -q /mnt/backupserver; then
        echo -e "${RED}ERROR: Backup server is not mounted at /mnt/backupserver.${NC}"
        echo -e "Please check the network connection and try again."
        exit 1
    fi
}

# 4. GLOBAL ORDER LOGIC FUNCTION
get_order_num() {
    if [ -f /tmp/alina_order ]; then
        ORDER_NUM=$(cat /tmp/alina_order)
    else
        echo -e "${CYAN}--------------------------------------------------${NC}"
        read -r -p "Enter Order Number (or press Enter to skip): " input_num
        
        if [[ -z "$input_num" ]]; then
            ORDER_NUM="No_Order"
        else
            ORDER_NUM="$input_num"
        fi
        
        echo "$ORDER_NUM" > /tmp/alina_order
        echo -e "${GREEN}Using Global Order Number: $ORDER_NUM${NC}"
        echo -e "${CYAN}--------------------------------------------------${NC}\n"
    fi
}
# EOF