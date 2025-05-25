#!/usr/bin/env bash

set -euo pipefail

# Configuration
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
THEME_SWITCHER_DIR="$CONFIG_DIR/theme-switcher"
CURRENT_THEME_FILE="$THEME_SWITCHER_DIR/current-theme"
AVAILABLE_THEMES_FILE="$THEME_SWITCHER_DIR/available-themes"

# Ensure directories exist
mkdir -p "$THEME_SWITCHER_DIR"

# Read available themes
if [[ -f "$AVAILABLE_THEMES_FILE" ]]; then
    mapfile -t AVAILABLE_THEMES < "$AVAILABLE_THEMES_FILE"
else
    AVAILABLE_THEMES=("one" "gruvbox" "everforest" "catppuccin")
fi

# Function to get current theme
get_current_theme() {
    if [[ -f "$CURRENT_THEME_FILE" ]]; then
        cat "$CURRENT_THEME_FILE"
    else
        echo "gruvbox"  # Default theme
    fi
}

# Function to reload applications
reload_applications() {
    local theme="$1"

    echo "Reloading applications for theme: $theme"

    # Reload Alacritty (if running)
    if pgrep alacritty > /dev/null; then
        echo "Reloading Alacritty..."
        # Alacritty will automatically pick up config changes
    fi

    # Reload Waybar
    if pgrep waybar > /dev/null; then
        echo "Reloading Waybar..."
        pkill waybar
        sleep 0.5
        waybar &
        disown
    fi

    # Reload Hyprland
    if command -v hyprctl &> /dev/null && pgrep Hyprland > /dev/null; then
        echo "Reloading Hyprland..."
        hyprctl reload || echo "Warning: Could not reload Hyprland config"
    fi

    # Reload Dunst
    if pgrep dunst > /dev/null; then
        echo "Reloading Dunst..."
        pkill dunst
        sleep 0.5
        dunst &
        disown
    fi

    # Reload Fish (apply theme to running sessions)
    if command -v fish &> /dev/null; then
        echo "Reloading Fish theme..."
        fish -c "source ~/.config/fish/themes/current.fish" 2>/dev/null || true
    fi

    # Reload Qtile (if running)
    if pgrep qtile > /dev/null && command -v qtile &> /dev/null; then
        echo "Reloading Qtile..."
        qtile cmd-obj -o cmd -f reload_config || echo "Warning: Could not reload Qtile"
    fi

    # Set wallpaper
    local wallpaper_path="$CONFIG_DIR/theme-variants/$theme/wallpaper"
    if [[ -f "$wallpaper_path" ]]; then
        echo "Setting wallpaper..."
        if command -v feh &> /dev/null; then
            feh --bg-scale "$wallpaper_path" || true
        fi
        if command -v swww &> /dev/null && pgrep swww-daemon > /dev/null; then
            swww img "$wallpaper_path" || true
        fi
        if command -v waypaper &> /dev/null; then
            waypaper --wallpaper "$wallpaper_path" || true
        fi
    fi

    # Send notification
    if command -v notify-send &> /dev/null; then
        notify-send "Theme Switcher" "Switched to theme: $theme" -t 3000
    fi
}

# Function to update symlinks for Nix-managed configs
update_nix_symlinks() {
    local theme="$1"

    echo "Updating symlinks for theme: $theme"

    # Alacritty
    if [[ -f "$CONFIG_DIR/alacritty/themes/$theme.toml" ]]; then
        ln -sf "$CONFIG_DIR/alacritty/themes/$theme.toml" "$CONFIG_DIR/alacritty/alacritty.toml"
    fi

    # Rofi
    if [[ -f "$CONFIG_DIR/rofi/themes/$theme.rasi" ]]; then
        ln -sf "$CONFIG_DIR/rofi/themes/$theme.rasi" "$CONFIG_DIR/rofi/config.rasi"
    fi

    # Wofi
    if [[ -f "$CONFIG_DIR/wofi/themes/$theme.css" ]]; then
        ln -sf "$CONFIG_DIR/wofi/themes/$theme.css" "$CONFIG_DIR/wofi/style.css"
    fi

    # Dunst
    if [[ -f "$CONFIG_DIR/dunst/themes/$theme.conf" ]]; then
        ln -sf "$CONFIG_DIR/dunst/themes/$theme.conf" "$CONFIG_DIR/dunst/dunstrc"
    fi

    # Fish
    if [[ -f "$CONFIG_DIR/fish/themes/$theme.fish" ]]; then
        ln -sf "$CONFIG_DIR/fish/themes/$theme.fish" "$CONFIG_DIR/fish/themes/current.fish"
    fi

    # Qtile
    if [[ -f "$CONFIG_DIR/qtile/themes/$theme.py" ]]; then
        ln -sf "$CONFIG_DIR/qtile/themes/$theme.py" "$CONFIG_DIR/qtile/current_theme.py"
    fi
}

# Function to update non-Nix configs (Hyprland, Waybar)
update_direct_configs() {
    local theme="$1"

    echo "Updating direct configs for theme: $theme"

    # Update Hyprland theme
    local hypr_theme_file="$CONFIG_DIR/theme-switcher/hyprland/$theme.conf"
    if [[ -f "$hypr_theme_file" ]] && [[ -f "$CONFIG_DIR/hypr/hyprland.conf" ]]; then
        # Replace the theme source line in hyprland.conf
        sed -i "s|source = ~/.config/theme-switcher/hyprland/.*\.conf|source = ~/.config/theme-switcher/hyprland/$theme.conf|g" \
            "$CONFIG_DIR/hypr/hyprland.conf"
    fi

    # Update Waybar theme
    local waybar_theme_file="$CONFIG_DIR/theme-switcher/waybar/$theme.css"
    if [[ -f "$waybar_theme_file" ]]; then
        cp "$waybar_theme_file" "$CONFIG_DIR/waybar/style.css"
    fi
}

# Function to set theme
set_theme() {
    local theme="$1"

    # Validate theme
    local theme_exists=false
    for available_theme in "${AVAILABLE_THEMES[@]}"; do
        if [[ "$available_theme" == "$theme" ]]; then
            theme_exists=true
            break
        fi
    done

    if [[ "$theme_exists" != "true" ]]; then
        echo "Error: Theme '$theme' not found. Available themes: ${AVAILABLE_THEMES[*]}"
        exit 1
    fi

    echo "Setting theme to: $theme"

    # Update Nix-managed configs via symlinks
    update_nix_symlinks "$theme"

    # Update non-Nix configs directly
    update_direct_configs "$theme"

    # Save current theme
    echo "$theme" > "$CURRENT_THEME_FILE"

    # Reload applications
    reload_applications "$theme"

    echo "Theme '$theme' applied successfully!"
}

# Function to rebuild Home Manager with new theme
rebuild_with_theme() {
    local theme="$1"

    echo "Rebuilding Home Manager with theme: $theme"

    # Create a temporary nix file to override the theme
    local temp_theme_file="/tmp/current-theme-override.nix"
    cat > "$temp_theme_file" << EOF
{ config, ... }: {
  myTheme.current = "$theme";
}
EOF

    # Run home-manager switch with the theme override
    if command -v home-manager &> /dev/null; then
        home-manager switch -f "$temp_theme_file" && rm -f "$temp_theme_file"
    else
        echo "home-manager command not found. Please rebuild manually."
        rm -f "$temp_theme_file"
        return 1
    fi
}

# Function to show Rofi menu
show_rofi_menu() {
    local current_theme
    current_theme=$(get_current_theme)

    # Create menu with current theme highlighted
    local menu_items=""
    for theme in "${AVAILABLE_THEMES[@]}"; do
        if [[ "$theme" == "$current_theme" ]]; then
            menu_items+="✓ $theme (current)\n"
        else
            menu_items+="  $theme\n"
        fi
    done

    # Show Rofi menu
    local selected
    selected=$(echo -e "$menu_items" | rofi -dmenu -i -p "Select Theme:" -theme-str '
        window { width: 300px; }
        listview { lines: 6; }
        element selected { background-color: #51afef; }
    ')

    if [[ -n "$selected" ]]; then
        # Extract theme name (remove checkmark and "(current)" if present)
        local theme_name
        theme_name=$(echo "$selected" | sed 's/^[✓ ]*//' | sed 's/ (current)$//')
        set_theme "$theme_name"
    fi
}

# Function to show help
show_help() {
    cat << EOF
Enhanced Theme Switcher for NixOS + Home Manager

Usage: $0 [COMMAND] [OPTIONS]

Commands:
  menu              Show Rofi theme selection menu (default)
  set <theme>       Set specific theme
  current           Show current theme
  list              List available themes
  rebuild <theme>   Rebuild Home Manager with new theme
  reload            Reload applications with current theme
  help              Show this help message

Examples:
  $0                    # Show menu
  $0 set gruvbox        # Set gruvbox theme
  $0 rebuild everforest # Rebuild with everforest theme
  $0 list               # List all themes

Available themes: ${AVAILABLE_THEMES[*]}
EOF
}

# Main script logic
case "${1:-menu}" in
    "menu")
        show_rofi_menu
        ;;
    "current")
        get_current_theme
        ;;
    "set")
        if [[ -z "${2:-}" ]]; then
            echo "Usage: $0 set <theme_name>"
            echo "Available themes: ${AVAILABLE_THEMES[*]}"
            exit 1
        fi
        set_theme "$2"
        ;;
    "list")
        echo "Available themes:"
        current_theme=$(get_current_theme)
        for theme in "${AVAILABLE_THEMES[@]}"; do
            if [[ "$theme" == "$current_theme" ]]; then
                echo "✓ $theme (current)"
            else
                echo "  $theme"
            fi
        done
        ;;
    "rebuild")
        if [[ -z "${2:-}" ]]; then
            echo "Usage: $0 rebuild <theme_name>"
            echo "Available themes: ${AVAILABLE_THEMES[*]}"
            exit 1
        fi
        rebuild_with_theme "$2"
        ;;
    "reload")
        current_theme=$(get_current_theme)
        reload_applications "$current_theme"
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac
