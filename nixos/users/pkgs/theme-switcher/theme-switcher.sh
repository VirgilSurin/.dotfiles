#!/usr/bin/env bash
# theme-switcher.sh

set -euo pipefail

# Configuration
THEMES_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/theme-switcher/themes"
WAYBAR_THEMES_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/theme-switcher/waybar-themes"
HYPR_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprland.conf"
WAYBAR_STYLE="${XDG_CONFIG_HOME:-$HOME/.config}/waybar/style.css"
CURRENT_THEME_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/theme-switcher/current-theme"

# Available themes
THEMES=("one" "gruvbox")

# Ensure directories exist
mkdir -p "$(dirname "$CURRENT_THEME_FILE")"
mkdir -p "$THEMES_DIR"
mkdir -p "$WAYBAR_THEMES_DIR"

# Function to get current theme
get_current_theme() {
    if [[ -f "$CURRENT_THEME_FILE" ]]; then
        cat "$CURRENT_THEME_FILE"
    else
        echo "one"  # Default theme
    fi
}

# Function to set theme
set_theme() {
    local theme="$1"

    if [[ ! " ${THEMES[*]} " =~ " $theme " ]]; then
        echo "Error: Theme '$theme' not found. Available themes: ${THEMES[*]}"
        exit 1
    fi

    echo "Setting theme to: $theme"

    # Update Hyprland config
    if [[ -f "$HYPR_CONFIG" ]]; then
        # Replace the source line for themes
        sed -i "s|source = .*themes/.*.conf|source = $THEMES_DIR/$theme.conf|g" "$HYPR_CONFIG"

        # Reload Hyprland
        if command -v hyprctl &> /dev/null; then
            hyprctl reload || echo "Warning: Could not reload Hyprland config"
        fi
    else
        echo "Warning: Hyprland config not found at $HYPR_CONFIG"
    fi

    # Update Waybar styles
    if [[ -f "$WAYBAR_THEMES_DIR/$theme.css" ]]; then
        cp "$WAYBAR_THEMES_DIR/$theme.css" "$WAYBAR_STYLE"

        # Restart Waybar
        if pgrep waybar > /dev/null; then
            pkill waybar
            sleep 0.5
            waybar &
        fi
    else
        echo "Warning: Waybar theme not found at $WAYBAR_THEMES_DIR/$theme.css"
    fi

    # Save current theme
    echo "$theme" > "$CURRENT_THEME_FILE"

    echo "Theme '$theme' applied successfully!"
}

# Function to show Rofi menu
show_rofi_menu() {
    local current_theme
    current_theme=$(get_current_theme)

    # Create menu with current theme highlighted
    local menu_items=""
    for theme in "${THEMES[@]}"; do
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
        listview { lines: 4; }
        element selected { background-color: #51afef; }
    ')

    if [[ -n "$selected" ]]; then
        # Extract theme name (remove checkmark and "(current)" if present)
        local theme_name
        theme_name=$(echo "$selected" | sed 's/^[✓ ]*//' | sed 's/ (current)$//')
        set_theme "$theme_name"
    fi
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
            echo "Available themes: ${THEMES[*]}"
            exit 1
        fi
        set_theme "$2"
        ;;
    "list")
        echo "Available themes:"
        for theme in "${THEMES[@]}"; do
            if [[ "$theme" == "$(get_current_theme)" ]]; then
                echo "✓ $theme (current)"
            else
                echo "  $theme"
            fi
        done
        ;;
    *)
        echo "Usage: $0 [menu|current|set <theme>|list]"
        echo "  menu    - Show Rofi theme selection menu (default)"
        echo "  current - Show current theme"
        echo "  set     - Set specific theme"
        echo "  list    - List available themes"
        exit 1
        ;;
esac
