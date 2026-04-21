#!/bin/bash
# ==============================================================================
# Script:      alina-env.sh
# Description: Global environment variables and standard functions for Alina Arch.
# Author:      Ralf R. (ralf.rangedahl@alina.se)
# Version:     2.0.3
# Date:        2026-04-21
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
        echo -e "${RED}❌ ERROR: Backup server is not mounted at /mnt/backupserver.${NC}"
        echo -e "Please check the network connection and try again."
        exit 1
    fi
}

# 4. GLOBAL ORDER LOGIC FUNCTION
get_order_num() {
    if [ -f /tmp/alina_order ]; then
        export ORDER_NUM=$(cat /tmp/alina_order)
        echo -e "Using Global Order Number: ${GREEN}${ORDER_NUM}${NC}\n"
    else
        read -r -p "Enter Order Number: " temp_order
        if [[ -z "$temp_order" ]]; then
            echo -e "${RED}❌ No Order Number entered. Aborting.${NC}"
            exit 1
        fi
        echo "$temp_order" > /tmp/alina_order
        export ORDER_NUM="$temp_order"
    fi
}
# ==============================================================================
# EOF - End of script
# ==============================================================================