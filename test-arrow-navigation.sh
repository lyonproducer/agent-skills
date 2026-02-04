#!/usr/bin/env bash

# Demo script to test arrow navigation
# This is a simplified version to quickly test the new UX

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}Arrow Navigation Demo${NC}"
echo -e "${CYAN}Testing new UX improvements${NC}"
echo ""

test_arrow_menu() {
    echo -e "${BOLD}Select your favorite frameworks:${NC}"
    echo -e "${CYAN}(↑/↓: Navigate, Space: Toggle, Enter: Confirm, a: All, n: None)${NC}"
    echo ""

    local options=("React" "Angular" "Vue" "Svelte" "Next.js")
    local selected=(false false false false false)
    local current=0
    local total=${#options[@]}

    # Hide cursor
    tput civis

    while true; do
        # Print menu
        for i in "${!options[@]}"; do
            local checkbox=" "
            local line_style=""
            
            # Check if selected
            if [ "${selected[$i]}" = true ]; then
                checkbox="${GREEN}✓${NC}"
            fi
            
            # Highlight current line
            if [ $i -eq $current ]; then
                line_style="${CYAN}❯ ${BOLD}"
            else
                line_style="  "
            fi
            
            echo -e "${line_style}[${checkbox}] ${options[$i]}${NC}"
        done
        
        echo ""
        echo -e "${YELLOW}Shortcuts: ${NC}a (all) | n (none)"
        
        # Read key
        read -rsn1 key
        
        # Handle arrow keys
        if [ "$key" = $'\x1b' ]; then
            read -rsn2 key
            case $key in
                '[A') # Up arrow
                    ((current--))
                    if [ $current -lt 0 ]; then
                        current=$((total - 1))
                    fi
                    ;;
                '[B') # Down arrow
                    ((current++))
                    if [ $current -ge $total ]; then
                        current=0
                    fi
                    ;;
            esac
        else
            case $key in
                ' ') # Space
                    selected[$current]=$([ "${selected[$current]}" = true ] && echo false || echo true)
                    ;;
                '') # Enter
                    break
                    ;;
                'a'|'A')
                    for i in "${!options[@]}"; do
                        selected[$i]=true
                    done
                    ;;
                'n'|'N')
                    for i in "${!options[@]}"; do
                        selected[$i]=false
                    done
                    ;;
            esac
        fi
        
        # Clear menu
        echo -en "\033[$((total + 2))A\033[J"
    done
    
    # Show cursor
    tput cnorm
    
    # Clear menu
    echo -en "\033[$((total + 2))A\033[J"
    
    # Show results
    echo -e "${GREEN}✓ Selection confirmed!${NC}"
    echo ""
    echo "You selected:"
    for i in "${!options[@]}"; do
        if [ "${selected[$i]}" = true ]; then
            echo -e "  ${GREEN}✓${NC} ${options[$i]}"
        fi
    done
}

# Run test
test_arrow_menu

echo ""
echo -e "${CYAN}Demo completed! Press any key to exit...${NC}"
read -rsn1
