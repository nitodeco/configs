#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

print_status() {
    echo "→ $1"
}

print_success() {
    echo "✓ $1"
}

print_error() {
    echo "✗ $1" >&2
}

create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ -L "$target" ]]; then
        rm "$target"
        print_status "Removed existing symlink: $target"
    elif [[ -e "$target" ]]; then
        local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
        mv "$target" "$backup"
        print_status "Backed up existing file to: $backup"
    fi
    
    local target_dir
    target_dir="$(dirname "$target")"
    if [[ ! -d "$target_dir" ]]; then
        mkdir -p "$target_dir"
        print_status "Created directory: $target_dir"
    fi
    
    ln -s "$source" "$target"
    print_success "Linked: $source → $target"
}

apply_zsh_configs() {
    print_status "Applying oh-my-zsh configurations..."
    
    local zsh_dir="$SCRIPT_DIR/zsh"
    
    if [[ -f "$zsh_dir/.p10k.zsh" ]]; then
        create_symlink "$zsh_dir/.p10k.zsh" "$HOME_DIR/.p10k.zsh"
    fi
    
    if [[ -f "$zsh_dir/.zshrc" ]]; then
        create_symlink "$zsh_dir/.zshrc" "$HOME_DIR/.zshrc"
    fi
    
    if [[ -f "$zsh_dir/.zshenv" ]]; then
        create_symlink "$zsh_dir/.zshenv" "$HOME_DIR/.zshenv"
    fi
    
    if [[ -f "$zsh_dir/.zprofile" ]]; then
        create_symlink "$zsh_dir/.zprofile" "$HOME_DIR/.zprofile"
    fi
}

apply_cursor_configs() {
    print_status "Applying Cursor configurations..."
    
    local cursor_dir="$HOME_DIR/.cursor"
    local cursor_commands_dir="$SCRIPT_DIR/cursor/commands"
    
    if [[ -d "$cursor_commands_dir" ]] && [[ -n "$(ls -A "$cursor_commands_dir" 2>/dev/null)" ]]; then
        local target_commands_dir="$cursor_dir/commands"
        mkdir -p "$target_commands_dir"
        for command_file in "$cursor_commands_dir"/*; do
            if [[ -f "$command_file" ]]; then
                local filename
                filename="$(basename "$command_file")"
                create_symlink "$command_file" "$target_commands_dir/$filename"
            fi
        done
    fi
}

apply_claude_configs() {
    print_status "Applying Claude Code configurations..."
    
    local claude_dir="$SCRIPT_DIR/claude"
    local target_claude_dir="$HOME_DIR/.claude"
    
    if [[ -f "$claude_dir/CLAUDE.md" ]]; then
        mkdir -p "$target_claude_dir"
        create_symlink "$claude_dir/CLAUDE.md" "$target_claude_dir/CLAUDE.md"
    fi
}

main() {
    echo "=========================================="
    echo "  Config Application Script"
    echo "=========================================="
    echo ""
    echo "Source: $SCRIPT_DIR"
    echo "Target: $HOME_DIR"
    echo ""
    
    apply_zsh_configs
    echo ""
    
    apply_cursor_configs
    echo ""
    
    apply_claude_configs
    echo ""
    
    echo "=========================================="
    print_success "Configuration applied successfully!"
    echo "=========================================="
}

main "$@"
