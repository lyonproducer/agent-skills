#!/bin/bash

# Angular + Ionic AI Agent Skills Installer
# Usage: ./setup.sh [--global|--project|--skill SKILL_NAME]

set -e

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"
CURSOR_GLOBAL="$HOME/.cursor/skills"
CURSOR_PROJECT=".cursor/skills"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Available skills (path relative to skills/)
AVAILABLE_SKILLS=(
    "angular/core"
    "angular/forms"
    "angular/performance"
    "ionic/angular/architect"
    "ionic/angular/capacitor"
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

# Install all skills globally
install_global() {
    print_info "Installing skills to: $CURSOR_GLOBAL"
    
    # Create directory if it doesn't exist
    mkdir -p "$CURSOR_GLOBAL"
    
    # Copy each skill
    local count=0
    for skill in "${AVAILABLE_SKILLS[@]}"; do
        if [ -d "$SKILLS_DIR/$skill" ]; then
            cp -r "$SKILLS_DIR/$skill" "$CURSOR_GLOBAL/"
            print_success "Installed: $skill"
            ((count++))
        else
            print_warning "Skipped: $skill (not found)"
        fi
    done
    
    echo ""
    print_success "Installed $count skills globally"
    print_info "Skills are now available in all your projects"
}

# Install all skills to project
install_project() {
    if [ ! -f "angular.json" ]; then
        print_error "Not an Angular project (angular.json not found)"
        print_info "Run this command from your Angular project root"
        exit 1
    fi
    
    print_info "Installing skills to: $CURSOR_PROJECT"
    
    # Create directory if it doesn't exist
    mkdir -p "$CURSOR_PROJECT"
    
    # Copy each skill
    local count=0
    for skill in "${AVAILABLE_SKILLS[@]}"; do
        if [ -d "$SKILLS_DIR/$skill" ]; then
            cp -r "$SKILLS_DIR/$skill" "$CURSOR_PROJECT/"
            print_success "Installed: $skill"
            ((count++))
        else
            print_warning "Skipped: $skill (not found)"
        fi
    done
    
    echo ""
    print_success "Installed $count skills to project"
    print_info "Don't forget to commit .cursor/skills/ to your repository"
}

# Install specific skill globally
install_skill() {
    local skill_name=$1
    
    if [ -z "$skill_name" ]; then
        print_error "Skill name required"
        echo "Usage: ./setup.sh --skill SKILL_NAME"
        list_skills
        exit 1
    fi
    
    # Check if skill exists
    if [ ! -d "$SKILLS_DIR/$skill_name" ]; then
        print_error "Skill not found: $skill_name"
        list_skills
        exit 1
    fi
    
    # Create directory if it doesn't exist
    mkdir -p "$CURSOR_GLOBAL"
    
    # Copy skill
    cp -r "$SKILLS_DIR/$skill_name" "$CURSOR_GLOBAL/"
    print_success "Installed: $skill_name to $CURSOR_GLOBAL"
}

# Show usage
show_usage() {
    echo "Usage: ./setup.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --global              Install all skills globally (~/.cursor/skills/)"
    echo "  --project             Install all skills to current project (.cursor/skills/)"
    echo "  --skill SKILL_NAME    Install specific skill globally"
    echo "  --list                List available skills"
    echo "  --help                Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./setup.sh --global                    # Install all skills globally"
    echo "  ./setup.sh --project                   # Install to current project"
    echo "  ./setup.sh --skill angular-core        # Install only angular-core"
    echo "  ./setup.sh --list                      # List available skills"
    echo ""
}

# Main script
main() {
    print_header
    check_skills_dir
    
    # Parse arguments
    case "${1:-}" in
        --global)
            install_global
            ;;
        --project)
            install_project
            ;;
        --skill)
            if [ -z "${2:-}" ]; then
                print_error "Skill name required"
                show_usage
                exit 1
            fi
            install_skill "$2"
            ;;
        --list)
            list_skills
            ;;
        --help|"")
            show_usage
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
    
    echo ""
    print_success "Setup complete!"
    echo ""
    print_info "Next steps:"
    echo "  1. Restart Cursor"
    echo "  2. Open a chat and type: 'What Angular skills are available?'"
    echo "  3. Start coding with AI assistance!"
    echo ""
    print_info "Documentation: https://github.com/lyonproducer/agent-skills"
    echo ""
}

main "$@"
