#!/usr/bin/env bash

# Angular + Ionic AI Agent Skills Installer
# Multi-assistant setup (agentskills.io style) + Cursor installer.
#
# Usage:
#   ./setup.sh                     # Interactive mode (select assistants & skills)
#   ./setup.sh --all               # Configure all assistants
#   ./setup.sh --claude            # Configure Claude Code
#   ./setup.sh --gemini            # Configure Gemini CLI
#   ./setup.sh --codex             # Configure Codex (OpenAI)
#   ./setup.sh --copilot           # Configure GitHub Copilot
#   ./setup.sh --kilocode          # Configure Kilocode
#   ./setup.sh --cursor            # Install skills to ./.cursor/skills (project-specific)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="$SCRIPT_DIR"
AGENTS_SKILLS=".agents/skills"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Selection flags (assistants)
SETUP_CLAUDE=false
SETUP_GEMINI=false
SETUP_CODEX=false
SETUP_COPILOT=false
SETUP_KILOCODE=false
SETUP_CURSOR=false

# Selected skills (for interactive mode) - using simple array approach
SELECTED_SKILLS_LIST=()

# Available skills (path relative to skills/)
AVAILABLE_SKILLS=(
    "angular/architecture"
    "angular/core"
    "angular/forms"
    "angular/performance"
    "ionic/angular/architecture"
    "ionic/angular/capacitor"
    "ionic/angular/migration-standalone"
)

# Helper functions
print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Angular + Ionic AI Agent Skills Installer${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_info() {
    echo -e "${BLUE}→${NC} $1"
}

update_self() {
    print_info "Updating skills and script from GitHub..."
    
    # try to download the latest version of the repo
    if npx degit lyonproducer/agent-skills/skills "$SCRIPT_DIR" --force; then
        print_success "Update completed successfully!"
        print_info "Restarting script to apply changes..."
        chmod +x "$0"
        # Restart by removing the --update flag to avoid loop
        exec "$0" "${@/--update/}" 
    else
        print_error "Error trying to update from GitHub."
        exit 1
    fi
}

show_assistants_menu() {
    echo -e "${BOLD}Which AI assistants do you use?${NC}"
    echo -e "${CYAN}(↑/↓: Navigate, ${BOLD}Space: Toggle${NC}${CYAN}, Enter: Confirm)${NC}"
    echo -e "${YELLOW}💡 Multi-select:${NC} Use ${BOLD}Space${NC} to select multiple assistants, then press ${BOLD}Enter${NC}"
    echo ""

    local options=("Claude Code" "Gemini CLI" "Codex (OpenAI)" "GitHub Copilot" "Kilocode" "Cursor")
    local selected=(false false false false false false)
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
        
        # Read key without timeout issues
        IFS= read -rsn1 key
        
        # Handle arrow keys (they send 3 bytes: ESC, [, A/B)
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
                ' ') # Space - toggle current (NOT enter!)
                    selected[$current]=$([ "${selected[$current]}" = true ] && echo false || echo true)
                    ;;
                $'\n'|$'\r'|'') # Enter - confirm and exit
                    break
                    ;;
                'a'|'A') # Select all
                    for i in "${!options[@]}"; do
                        selected[$i]=true
                    done
                    ;;
                'n'|'N') # Select none
                    for i in "${!options[@]}"; do
                        selected[$i]=false
                    done
                    ;;
            esac
        fi
        
        # Clear menu (total lines + 2 for shortcuts)
        echo -en "\033[$((total + 2))A\033[J"
    done
    
    # Show cursor again
    tput cnorm
    
    # Clear menu
    echo -en "\033[$((total + 2))A\033[J"

    SETUP_CLAUDE=${selected[0]}
    SETUP_GEMINI=${selected[1]}
    SETUP_CODEX=${selected[2]}
    SETUP_COPILOT=${selected[3]}
    SETUP_KILOCODE=${selected[4]}
    SETUP_CURSOR=${selected[5]}
}

show_skills_menu() {
    # Detect already installed skills
    local installed=($(get_installed_skills))
    local available_to_install=($(get_available_skills_to_install))
    
    # Show already installed skills if any
    if [ ${#installed[@]} -gt 0 ]; then
        echo -e "${GREEN}✓ Already installed (${#installed[@]} skills):${NC}"
        for skill in "${installed[@]}"; do
            echo -e "  ${GREEN}✓${NC} $skill"
        done
        echo ""
        
        # Ask if user wants to reinstall or add new
        echo -e "${YELLOW}Options:${NC}"
        echo -e "  ${YELLOW}c${NC}. Continue (install new skills only)"
        echo -e "  ${YELLOW}r${NC}. Reinstall (show all skills including installed)"
        echo ""
        echo -n "Choose option (c/r): "
        
        read -r reinstall_choice
        echo ""
        
        if [ "$reinstall_choice" = "r" ] || [ "$reinstall_choice" = "R" ]; then
            # Show all skills for reinstallation
            available_to_install=("${AVAILABLE_SKILLS[@]}")
            echo -e "${BOLD}Showing all skills (including installed):${NC}"
            echo ""
        fi
    fi
    
    # Check if there are skills to install
    if [ ${#available_to_install[@]} -eq 0 ]; then
        echo -e "${GREEN}✓ All skills are already installed!${NC}"
        echo ""
        echo "Nothing to install. Use option 'r' to reinstall if needed."
        return
    fi
    
    echo -e "${BOLD}Which skills do you want to install?${NC}"
    echo -e "${CYAN}(↑/↓: Navigate, ${BOLD}Space: Toggle${NC}${CYAN}, Enter: Confirm)${NC}"
    echo -e "${YELLOW}💡 Multi-select:${NC} Use ${BOLD}Space${NC} to select multiple skills, then press ${BOLD}Enter${NC}"
    echo ""

    local selected=()
    for skill in "${available_to_install[@]}"; do
        selected+=(true)  # Default all to selected
    done

    local current=0
    local total=${#available_to_install[@]}

    # Hide cursor
    tput civis

    while true; do
        # Print menu
        for i in "${!available_to_install[@]}"; do
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
            
            echo -e "${line_style}[${checkbox}] ${available_to_install[$i]}${NC}"
        done
        
        echo ""
        echo -e "${YELLOW}Shortcuts: ${NC}a (all) | n (none)"
        
        # Read key without timeout issues
        IFS= read -rsn1 key
        
        # Handle arrow keys (they send 3 bytes: ESC, [, A/B)
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
                ' ') # Space - toggle current (NOT enter!)
                    selected[$current]=$([ "${selected[$current]}" = true ] && echo false || echo true)
                    ;;
                $'\n'|$'\r'|'') # Enter - confirm and exit
                    break
                    ;;
                'a'|'A') # Select all
                    for i in "${!available_to_install[@]}"; do
                        selected[$i]=true
                    done
                    ;;
                'n'|'N') # Select none
                    for i in "${!available_to_install[@]}"; do
                        selected[$i]=false
                    done
                    ;;
            esac
        fi
        
        # Clear menu (total lines + 2 for shortcuts)
        echo -en "\033[$((total + 2))A\033[J"
    done
    
    # Show cursor again
    tput cnorm
    
    # Clear menu
    echo -en "\033[$((total + 2))A\033[J"

    # Store selected skills
    SELECTED_SKILLS_LIST=()
    for i in "${!available_to_install[@]}"; do
        if [ "${selected[$i]}" = true ]; then
            SELECTED_SKILLS_LIST+=("${available_to_install[$i]}")
        fi
    done
}

# Get installed skills by reading .agents/skills/ directory (source of truth)
get_installed_skills() {
    local installed=()
    if [ -d "$AGENTS_SKILLS" ]; then
        # search for directories that have files inside and are at depth 2 or 3
        while IFS= read -r -d '' dir; do
            # check if it contains files to not count empty directories
            if [ -n "$(ls -A "$dir" 2>/dev/null)" ]; then
                local rel_path="${dir#$AGENTS_SKILLS/}"
                # only accept if it has a subdirectory structure (e.g. angular/core)
                # and not an intermediate directory like "ionic/angular"
                if [[ "$rel_path" == *"/"* ]]; then
                    # if it is ionic/angular/architecture, it is valid.
                    # but we need to filter to not count 'ionic/angular' if it is only the parent.
                    # a easy way is to check if there are subdirectories. 
                    # if it does not have subdirectories, it is a final skill.
                    if [ $(find "$dir" -mindepth 1 -type d | wc -l) -eq 0 ]; then
                        installed+=("$rel_path")
                    fi
                fi
            fi
        done < <(find "$AGENTS_SKILLS" -mindepth 2 -maxdepth 4 -type d -print0)
    fi
    printf '%s\n' "${installed[@]}"
}

# Get available skills to install (filter out already installed)
get_available_skills_to_install() {
    local installed=($(get_installed_skills))
    local available=()
    
    for skill in "${AVAILABLE_SKILLS[@]}"; do
        local is_installed=false
        for inst in "${installed[@]}"; do
            if [ "$skill" == "$inst" ]; then
                is_installed=true
                break
            fi
        done
        
        if [ "$is_installed" = false ]; then
            available+=("$skill")
        fi
    done
    printf '%s\n' "${available[@]}"
}

# Show installation status
show_status() {
    local installed=($(get_installed_skills))
    local total=${#AVAILABLE_SKILLS[@]}
    local installed_count=${#installed[@]}
    local available_count=$((total - installed_count))
    
    echo ""
    echo -e "${BOLD}Skills Installation Status${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    if [ ${#installed[@]} -eq 0 ]; then
        echo -e "${YELLOW}✗ No skills installed yet${NC}"
        echo ""
        echo -e "Available skills to install: ${BOLD}$total${NC}"
    else
        echo -e "${GREEN}✓ Installed Skills ($installed_count/$total):${NC}"
        for skill in "${installed[@]}"; do
            echo -e "  ${GREEN}✓${NC} $skill"
        done
        echo ""
        
        if [ $available_count -gt 0 ]; then
            echo -e "${YELLOW}○ Available to Install ($available_count/$total):${NC}"
            local available_list=($(get_available_skills_to_install))
            for skill in "${available_list[@]}"; do
                echo -e "  ${YELLOW}○${NC} $skill"
            done
        else
            echo -e "${GREEN}✓ All skills are installed!${NC}"
        fi
    fi
    
    echo ""
    echo -e "${BLUE}Installation Path:${NC} ./.agents/skills/"
    echo -e "${BLUE}Symlinks:${NC} .cursor/skills/, .kilocode/skills/, etc. → .agents/skills/"
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [ $available_count -gt 0 ] || [ ${#installed[@]} -eq 0 ]; then
        echo ""
        echo -e "${CYAN}To install skills:${NC}"
        echo "  ./setup.sh           # Interactive mode"
        echo "  ./setup.sh --cursor  # Install to current project"
    fi
    echo ""
}

# Check if skills directory exists
check_skills_dir() {
    if [ ! -d "$SKILLS_DIR" ]; then
        print_error "Skills directory not found: $SKILLS_DIR"
        exit 1
    fi
}

# List available skills
list_skills() {
    echo -e "${BLUE}Available Skills:${NC}"
    echo ""
    for skill in "${AVAILABLE_SKILLS[@]}"; do
        if [ -d "$SKILLS_DIR/$skill" ]; then
            print_success "$skill"
        else
            print_warning "$skill (not found)"
        fi
    done
    echo ""
}

# Install selected skills to .agents/skills (source of truth)
install_skills_to_agents() {
    if [ ! -f "angular.json" ]; then
        print_error "Not an Angular project (angular.json not found)"
        print_info "Run this command from your Angular project root"
        exit 1
    fi
    
    # Create .agents/skills directory if it doesn't exist
    mkdir -p "$AGENTS_SKILLS"
    
    # Determine which skills to install
    local skills_to_install=()
    if [ ${#SELECTED_SKILLS_LIST[@]} -gt 0 ]; then
        # Use selected skills
        skills_to_install=("${SELECTED_SKILLS_LIST[@]}")
    else
        # Use all skills
        skills_to_install=("${AVAILABLE_SKILLS[@]}")
    fi
    
    # Copy each skill
    local count=0
    for skill in "${skills_to_install[@]}"; do
        if [ -d "$SKILLS_DIR/$skill" ]; then

            # Extract skill name for flat installation
            # local skill_name=$(basename "$skill")
            # local target_path="$AGENTS_SKILLS/$skill_name"

            # Create target path
            local target_path="$AGENTS_SKILLS/$skill"
            local target_parent=$(dirname "$target_path")

            # Create parent directory if it doesn't exist
            if [ ! -d "$target_parent" ]; then
                mkdir -p "$target_parent"
            fi

            # Remove existing if present
            if [ -d "$target_path" ]; then
                rm -rf "$target_path"
            fi
            
            cp -r "$SKILLS_DIR/$skill" "$target_path"
            print_success "Installed: $skill"
            ((count++))
        else
            print_warning "Skipped: $skill (not found)"
        fi
    done
    
    echo ""
    print_success "Installed $count skills to .agents/skills/"
    print_info "Skills are now available for all assistants via symlinks"
}

ensure_dir() {
    local target="$1"
    if [ ! -d "$target" ]; then
        mkdir -p "$target"
    fi
}

replace_link() {
    local target="$1"
    local source="$2"

    if [ -L "$target" ]; then
        rm "$target"
    elif [ -d "$target" ]; then
        mv "$target" "${target}.backup.$(date +%s)"
    fi

    ln -s "$source" "$target"
}

copy_agents_md() {
    local target_name="$1"
    local agents_file="$SCRIPT_DIR/AGENTS.md"
    
    if [ -f "$agents_file" ]; then
        cp "$agents_file" "$REPO_ROOT/$target_name"
        print_success "Copied AGENTS.md -> $target_name"
    else
        print_warning "AGENTS.md not found at $SCRIPT_DIR"
    fi
}

# Create symlink for Cursor to .agents/skills
setup_cursor() {
    local target="$REPO_ROOT/.cursor/skills"
    ensure_dir "$REPO_ROOT/.cursor"
    
    # Remove existing .cursor/skills if it exists
    if [ -L "$target" ]; then
        rm "$target"
    elif [ -d "$target" ]; then
        mv "$target" "${target}.backup.$(date +%s)"
        print_warning "Backed up existing .cursor/skills to ${target}.backup.*"
    fi
    
    # Create symlink to .agents/skills
    ln -s "../$AGENTS_SKILLS" "$target"
    
    print_success ".cursor/skills -> .agents/skills/"
    copy_agents_md
    print_success "Cursor uses AGENTS.md natively"
}

setup_claude() {
    local target="$REPO_ROOT/.claude/skills"
    ensure_dir "$REPO_ROOT/.claude"
    
    # Remove existing
    if [ -L "$target" ]; then
        rm "$target"
    elif [ -d "$target" ]; then
        mv "$target" "${target}.backup.$(date +%s)"
    fi
    
    # Create symlink to .agents/skills
    ln -s "../$AGENTS_SKILLS" "$target"
    print_success ".claude/skills -> .agents/skills/"
    copy_agents_md "CLAUDE.md"
}

setup_gemini() {
    local target="$REPO_ROOT/.gemini/skills"
    ensure_dir "$REPO_ROOT/.gemini"
    
    # Remove existing
    if [ -L "$target" ]; then
        rm "$target"
    elif [ -d "$target" ]; then
        mv "$target" "${target}.backup.$(date +%s)"
    fi
    
    # Create symlink to .agents/skills
    ln -s "../$AGENTS_SKILLS" "$target"
    print_success ".gemini/skills -> .agents/skills/"
    copy_agents_md "GEMINI.md"
}

setup_codex() {
    local target="$REPO_ROOT/.codex/skills"
    ensure_dir "$REPO_ROOT/.codex"
    
    # Remove existing
    if [ -L "$target" ]; then
        rm "$target"
    elif [ -d "$target" ]; then
        mv "$target" "${target}.backup.$(date +%s)"
    fi
    
    # Create symlink to .agents/skills
    ln -s "../$AGENTS_SKILLS" "$target"
    print_success ".codex/skills -> .agents/skills/"
    copy_agents_md
    print_success "Codex uses AGENTS.md natively"
}

setup_copilot() {
    if [ -f "$SCRIPT_DIR/AGENTS.md" ]; then
        ensure_dir "$REPO_ROOT/.github"
        cp "$SCRIPT_DIR/AGENTS.md" "$REPO_ROOT/.github/copilot-instructions.md"
        print_success "AGENTS.md -> .github/copilot-instructions.md"
    else
        print_warning "AGENTS.md not found at skills directory"
    fi
}

setup_kilocode() {
    local target="$REPO_ROOT/.kilocode/skills"
    ensure_dir "$REPO_ROOT/.kilocode"
    
    # Remove existing
    if [ -L "$target" ]; then
        rm "$target"
    elif [ -d "$target" ]; then
        mv "$target" "${target}.backup.$(date +%s)"
    fi
    
    # Create symlink to .agents/skills
    ln -s "../$AGENTS_SKILLS" "$target"
    print_success ".kilocode/skills -> .agents/skills/"
    copy_agents_md
    print_success "Kilocode uses AGENTS.md natively"
}

# Show usage
show_usage() {
    echo "Usage: ./setup.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --all                 Configure all AI assistants"
    echo "  --claude              Configure Claude Code (.claude/skills + CLAUDE.md)"
    echo "  --gemini              Configure Gemini CLI (.gemini/skills + GEMINI.md)"
    echo "  --codex               Configure Codex (.codex/skills + AGENTS.md)"
    echo "  --copilot             Configure GitHub Copilot (.github/copilot-instructions.md)"
    echo "  --kilocode            Configure Kilocode (.kilocode/skills + AGENTS.md)"
    echo "  --cursor              Configure Cursor (.cursor/skills + AGENTS.md)"
    echo "  --list                List available skills"
    echo "  --status              Show installed vs available skills"
    echo "  --help                Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./setup.sh                             # Interactive mode"
    echo "  ./setup.sh --all                       # Configure all assistants"
    echo "  ./setup.sh --claude --codex --kilocode # Multiple assistants"
    echo "  ./setup.sh --cursor                    # Install to current project"
    echo "  ./setup.sh --status                    # Check installation status"
    echo "  ./setup.sh --list                      # List available skills"
    echo ""
}

# Main script
main() {
    print_header
    check_skills_dir
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --update)
                update_self "$@"
                exit 0
                ;;
            --all)
                SETUP_CLAUDE=true
                SETUP_GEMINI=true
                SETUP_CODEX=true
                SETUP_COPILOT=true
                SETUP_KILOCODE=true
                SETUP_CURSOR=true
                shift
                ;;
            --claude)
                SETUP_CLAUDE=true
                shift
                ;;
            --gemini)
                SETUP_GEMINI=true
                shift
                ;;
            --codex)
                SETUP_CODEX=true
                shift
                ;;
            --copilot)
                SETUP_COPILOT=true
                shift
                ;;
            --kilocode)
                SETUP_KILOCODE=true
                shift
                ;;
            --cursor)
                SETUP_CURSOR=true
                shift
                ;;
            --list)
                list_skills
                exit 0
                ;;
            --status)
                show_status
                exit 0
                ;;
            --help|-h|"")
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    # Interactive mode if no flags provided
    if [ "$SETUP_CLAUDE" = false ] && [ "$SETUP_GEMINI" = false ] && [ "$SETUP_CODEX" = false ] && [ "$SETUP_COPILOT" = false ] && [ "$SETUP_KILOCODE" = false ] && [ "$SETUP_CURSOR" = false ]; then
        show_assistants_menu
        echo ""
        
        # Show selected assistants summary
        local selected_count=0
            [ "$SETUP_CLAUDE" = true ] && ((selected_count++))
            [ "$SETUP_GEMINI" = true ] && ((selected_count++))
            [ "$SETUP_CODEX" = true ] && ((selected_count++))
            [ "$SETUP_COPILOT" = true ] && ((selected_count++))
            [ "$SETUP_KILOCODE" = true ] && ((selected_count++))
            [ "$SETUP_CURSOR" = true ] && ((selected_count++))
        
        if [ $selected_count -eq 0 ]; then
            print_warning "No assistants selected. Exiting."
            exit 0
        fi
        
        echo -e "${GREEN}✓ Selected $selected_count assistant(s):${NC}"
        [ "$SETUP_CLAUDE" = true ] && echo -e "  ${GREEN}✓${NC} Claude Code"
        [ "$SETUP_GEMINI" = true ] && echo -e "  ${GREEN}✓${NC} Gemini CLI"
        [ "$SETUP_CODEX" = true ] && echo -e "  ${GREEN}✓${NC} Codex (OpenAI)"
        [ "$SETUP_COPILOT" = true ] && echo -e "  ${GREEN}✓${NC} GitHub Copilot"
        [ "$SETUP_KILOCODE" = true ] && echo -e "  ${GREEN}✓${NC} Kilocode"
        [ "$SETUP_CURSOR" = true ] && echo -e "  ${GREEN}✓${NC} Cursor"
        echo ""
        
        # If any assistant was selected, ask which skills
        if [ "$SETUP_CLAUDE" = true ] || [ "$SETUP_GEMINI" = true ] || [ "$SETUP_CODEX" = true ] || [ "$SETUP_COPILOT" = true ] || [ "$SETUP_KILOCODE" = true ] || [ "$SETUP_CURSOR" = true ]; then
            show_skills_menu
            echo ""
            
            # Show selected skills summary
            if [ ${#SELECTED_SKILLS_LIST[@]} -eq 0 ]; then
                print_warning "No skills selected. Will configure assistants without installing skills."
                echo ""
            else
                echo -e "${GREEN}✓ Selected ${#SELECTED_SKILLS_LIST[@]} skill(s):${NC}"
                for skill in "${SELECTED_SKILLS_LIST[@]}"; do
                    echo -e "  ${GREEN}✓${NC} $skill"
                done
                echo ""
            fi
        fi
    fi

    # First, install skills to .agents/skills if any assistant or cursor was selected
    local any_selected=false
    [ "$SETUP_CLAUDE" = true ] || [ "$SETUP_GEMINI" = true ] || [ "$SETUP_CODEX" = true ] || \
    [ "$SETUP_COPILOT" = true ] || [ "$SETUP_KILOCODE" = true ] || [ "$SETUP_CURSOR" = true ] && any_selected=true
    
    if [ "$any_selected" = true ] && [ ${#SELECTED_SKILLS_LIST[@]} -gt 0 ]; then
        print_info "Installing skills to .agents/skills/..."
        install_skills_to_agents
        echo ""
    fi

    # Now setup symlinks for each selected assistant
    if [ "$SETUP_CLAUDE" = true ]; then
        print_info "Setting up Claude Code..."
        setup_claude
        echo ""
    fi

    if [ "$SETUP_GEMINI" = true ]; then
        print_info "Setting up Gemini CLI..."
        setup_gemini
        echo ""
    fi

    if [ "$SETUP_CODEX" = true ]; then
        print_info "Setting up Codex (OpenAI)..."
        setup_codex
        echo ""
    fi

    if [ "$SETUP_COPILOT" = true ]; then
        print_info "Setting up GitHub Copilot..."
        setup_copilot
        echo ""
    fi

    if [ "$SETUP_KILOCODE" = true ]; then
        print_info "Setting up Kilocode..."
        setup_kilocode
        echo ""
    fi

    if [ "$SETUP_CURSOR" = true ]; then
        print_info "Setting up Cursor..."
        setup_cursor
        echo ""
    fi
    
    echo ""
    print_success "Setup complete!"
    echo ""
    print_info "Next steps:"
    echo "  1. Restart your AI assistant"
    echo "  2. Verify skills are detected asking the AI assistant"
    echo "  3. Add .agents/skills/*, ./skills/AGENTS.md, ./skills to gitignore if dont want to commit them"
    echo "  4. Start coding with AI assistance!"
    echo ""
    print_info "Documentation: https://github.com/lyonproducer/agent-skills"
    echo ""
}

main "$@"
