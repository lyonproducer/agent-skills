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

clear
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}  Arrow Navigation Demo - Multi-Select${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}This demo shows how to select MULTIPLE options in each menu.${NC}"
echo -e "${CYAN}You can select as many options as you want!${NC}"
echo ""
echo -e "${YELLOW}Instructions:${NC}"
echo -e "  • Use ↑/↓ arrows to navigate"
echo -e "  • Press ${BOLD}Space${NC} to toggle selection (can select multiple!)"
echo -e "  • Press ${BOLD}Enter${NC} to confirm your selections"
echo -e "  • Press ${BOLD}a${NC} to select all / ${BOLD}n${NC} to select none"
echo ""
read -p "Press Enter to start the demo..." -r
clear
echo ""

select_menu() {
    local title="$1"
    shift
    local options=("$@")

    echo -e "${BOLD}${title}${NC}" >&2
    echo -e "${CYAN}(↑/↓: Navigate, ${BOLD}Space: Toggle${NC}${CYAN}, Enter: Confirm)${NC}" >&2
    echo -e "${YELLOW}💡 Multi-select enabled:${NC} Use ${BOLD}Space${NC} to select multiple options!" >&2
    echo "" >&2

    local selected=()
    local i
    for i in "${!options[@]}"; do
        selected+=(false)
    done
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
            
            echo -e "${line_style}[${checkbox}] ${options[$i]}${NC}" >&2
        done
        
        echo "" >&2
        echo -e "${YELLOW}Shortcuts: ${NC}a (all) | n (none)" >&2
        
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
        echo -en "\033[$((total + 2))A\033[J" >&2
    done
    
    # Show cursor
    tput cnorm
    
    # Clear menu
    echo -en "\033[$((total + 2))A\033[J" >&2
    
    # Return selected options
    local selected_items=()
    for i in "${!options[@]}"; do
        if [ "${selected[$i]}" = true ]; then
            selected_items+=("${options[$i]}")
        fi
    done

    printf '%s\n' "${selected_items[@]}"
}

echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}  Step 1: Select Assistants (Can select multiple)${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
assistants_selected=()
assistants_output="$(select_menu "Which AI assistants do you want to configure?" \
    "Claude Code" "Gemini CLI" "Codex (OpenAI)" "GitHub Copilot" "Kilocode")"
while IFS= read -r line; do
    [ -z "$line" ] && continue
    assistants_selected+=("$line")
done <<< "$assistants_output"

echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}  Step 2: Select Skills (Can select multiple)${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
skills_selected=()
skills_output="$(select_menu "Which skills do you want to install?" \
    "angular/core" "angular/forms" "angular/performance" \
    "ionic/angular/architecture" "ionic/angular/capacitor" "ionic/angular/migration-standalone")"
while IFS= read -r line; do
    [ -z "$line" ] && continue
    skills_selected+=("$line")
done <<< "$skills_output"

clear
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}  Final Summary - Multi-Select Results${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}✓ Selections confirmed!${NC}"
echo ""

echo -e "${BOLD}Assistants to configure (${#assistants_selected[@]} selected):${NC}"
if [ ${#assistants_selected[@]} -eq 0 ]; then
    echo -e "  ${YELLOW}⚠${NC} No assistants selected"
else
    for item in "${assistants_selected[@]}"; do
        echo -e "  ${GREEN}✓${NC} $item"
    done
fi

echo ""
echo -e "${BOLD}Skills to install (${#skills_selected[@]} selected):${NC}"
if [ ${#skills_selected[@]} -eq 0 ]; then
    echo -e "  ${YELLOW}⚠${NC} No skills selected"
else
    for item in "${skills_selected[@]}"; do
        echo -e "  ${GREEN}✓${NC} $item"
    done
fi

echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}💡 This demonstrates MULTI-SELECT functionality:${NC}"
echo -e "   You selected ${BOLD}${#assistants_selected[@]}${NC} assistants and ${BOLD}${#skills_selected[@]}${NC} skills!"
echo ""
echo -e "${CYAN}Press any key to exit...${NC}"
read -rsn1
