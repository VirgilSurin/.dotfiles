{ config, lib, pkgs, inputs, ... }:

let
  # Define your themes using nix-colors
  themes = {
    one = {
      scheme = inputs.nix-colors.colorSchemes.onedark;
      wallpaper = ../../../wallpapers/ign_sunGarden.png;
    };
    gruvbox = {
      scheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
      wallpaper = ../../../wallpapers/boat_painting.jpg;
    };
    everforest = {
      scheme = inputs.nix-colors.colorSchemes.everforest;
      wallpaper = ../../../wallpapers/star-wars-naboo-wallpapers.png;
    };
  };

  # Function to generate theme files for each app
  generateThemeFiles = themeName: themeData: {
    # Alacritty
    "unified-themes/alacritty-${themeName}.toml" = {
      text = ''
        [colors.primary]
        background = "#${themeData.scheme.palette.base00}"
        foreground = "#${themeData.scheme.palette.base05}"

        [colors.normal]
        black = "#${themeData.scheme.palette.base03}"
        red = "#${themeData.scheme.palette.base08}"
        green = "#${themeData.scheme.palette.base0B}"
        yellow = "#${themeData.scheme.palette.base0A}"
        blue = "#${themeData.scheme.palette.base0D}"
        magenta = "#${themeData.scheme.palette.base0E}"
        cyan = "#${themeData.scheme.palette.base0C}"
        white = "#${themeData.scheme.palette.base06}"

        [colors.bright]
        black = "#${themeData.scheme.palette.base04}"
        red = "#${themeData.scheme.palette.base08}"
        green = "#${themeData.scheme.palette.base0B}"
        yellow = "#${themeData.scheme.palette.base0A}"
        blue = "#${themeData.scheme.palette.base0D}"
        magenta = "#${themeData.scheme.palette.base0E}"
        cyan = "#${themeData.scheme.palette.base0C}"
        white = "#${themeData.scheme.palette.base07}"

        [window]
        opacity = 1.0
        [window.padding]
        x = 6
        y = 6

        [font]
        size = 10
      '';
    };

    # Hyprland colors
    "unified-themes/hyprland-${themeName}.conf" = {
      text = ''
        $bg = 0xff${themeData.scheme.palette.base00}
        $fg = 0xff${themeData.scheme.palette.base05}
        $black = 0xff${themeData.scheme.palette.base03}
        $white = 0xff${themeData.scheme.palette.base07}
        $red = 0xff${themeData.scheme.palette.base08}
        $green = 0xff${themeData.scheme.palette.base0B}
        $orange = 0xff${themeData.scheme.palette.base09}
        $blue = 0xff${themeData.scheme.palette.base0D}
        $magenta = 0xff${themeData.scheme.palette.base0E}
        $cyan = 0xff${themeData.scheme.palette.base0C}
        $purple = 0xff${themeData.scheme.palette.base0E}
      '';
    };

    # Waybar CSS
    "unified-themes/waybar-${themeName}.css" = {
      text = ''
        * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font";
          font-size: 10px;
          min-height: 1px;
        }

        window#waybar {
          background: #${themeData.scheme.palette.base00};
          color: #${themeData.scheme.palette.base05};
        }

        #custom-menu {
          color: #${themeData.scheme.palette.base0D};
          font-size: 14px;
          padding: 0 10px;
        }

        #workspaces {
          background-color: transparent;
          padding: 0px;
        }

        #workspaces button {
          color: #${themeData.scheme.palette.base0D};
          background: transparent;
          margin: 2px;
          border-bottom: 2px solid transparent;
          padding: 0px;
        }

        #workspaces button.active {
          border-bottom: 2px solid #${themeData.scheme.palette.base0B};
        }

        #workspaces button.visible:not(.active) {
          border-bottom: 2px solid #${themeData.scheme.palette.base0D};
        }

        #window {
          color: #${themeData.scheme.palette.base0D};
          padding-left: 10px;
        }

        #language { color: #${themeData.scheme.palette.base09}; padding: 0 6px; }
        #bluetooth { color: #${themeData.scheme.palette.base0C}; padding: 0 6px; }
        #network { color: #${themeData.scheme.palette.base08}; padding: 0 6px; }
        #pulseaudio { color: #${themeData.scheme.palette.base0E}; padding: 0 6px; }
        #battery { color: #${themeData.scheme.palette.base0B}; padding: 0 6px; }
        #clock { color: #${themeData.scheme.palette.base0D}; padding: 0 6px; }
        #tray { padding: 0 6px; }
      '';
    };

    # Qtile theme
    "unified-themes/qtile-${themeName}.py" = {
      text = ''
        ${themeName} = {
            "bg":      "#${themeData.scheme.palette.base00}",
            "fg":      "#${themeData.scheme.palette.base05}",
            "black":   "#${themeData.scheme.palette.base03}",
            "white":   "#${themeData.scheme.palette.base07}",
            "red":     "#${themeData.scheme.palette.base08}",
            "green":   "#${themeData.scheme.palette.base0B}",
            "orange":  "#${themeData.scheme.palette.base09}",
            "blue":    "#${themeData.scheme.palette.base0D}",
            "magenta": "#${themeData.scheme.palette.base0E}",
            "cyan":    "#${themeData.scheme.palette.base0C}",
            "purple":  "#${themeData.scheme.palette.base0E}"
        }
      '';
    };

    # Rofi theme
    "unified-themes/rofi-${themeName}.rasi" = {
      text = ''
        * {
          background-color: #${themeData.scheme.palette.base00};
          border-color: #${themeData.scheme.palette.base08};
          text-color: #${themeData.scheme.palette.base05};
          font: "JetBrainsMono Nerd Font 12";
        }

        #window {
          width: 30%;
          border: 2;
          padding: 5;
        }

        #listview {
          border: 2px solid 0px 0px;
          border-color: #${themeData.scheme.palette.base01};
          spacing: 2px;
          scrollbar: true;
          padding: 2px 0px 0px;
        }

        #element.selected.normal {
          background-color: #${themeData.scheme.palette.base0D};
          text-color: #${themeData.scheme.palette.base00};
        }
      '';
    };

    # Wofi theme
    "unified-themes/wofi-${themeName}.css" = {
      text = ''
        * {
          font-family: JetBrainsMono Nerd Font Bold;
          font-size: 16px;
          outline-style: none;
        }

        #window {
          margin: 0px;
          border: 2px solid #${themeData.scheme.palette.base08};
          background-color: #${themeData.scheme.palette.base00};
        }

        #input {
          margin: 16px;
          background-color: #${themeData.scheme.palette.base00};
          color: #${themeData.scheme.palette.base05};
          border: transparent;
        }

        #entry:selected {
          background-color: #${themeData.scheme.palette.base04};
        }

        #entry > box {
          color: #${themeData.scheme.palette.base05};
        }
      '';
    };

    # Dunst theme
    "unified-themes/dunst-${themeName}.conf" = {
      text = ''
        [global]
        follow = keyboard
        offset = 10x34
        padding = 8
        horizontal_padding = 8
        frame_width = 2
        frame_color = "#${themeData.scheme.palette.base08}"
        font = JetBrainsMono Nerd Font Bold 12
        corner_radius = 0

        [urgency_low]
        background = "#${themeData.scheme.palette.base00}"
        foreground = "#${themeData.scheme.palette.base05}"
        timeout = 5

        [urgency_normal]
        background = "#${themeData.scheme.palette.base00}"
        foreground = "#${themeData.scheme.palette.base05}"
        timeout = 5

        [urgency_critical]
        background = "#${themeData.scheme.palette.base00}"
        foreground = "#${themeData.scheme.palette.base05}"
        frame_color = "#${themeData.scheme.palette.base08}"
        timeout = 10
      '';
    };

    # Wallpaper symlink
    "unified-themes/wallpaper-${themeName}" = {
      source = themeData.wallpaper;
    };
  };

in {
  config = {
    # Generate all theme files
    home.file = lib.mkMerge (lib.mapAttrsToList generateThemeFiles themes);

    # Install the theme switcher
    home.packages = [
      (pkgs.callPackage ../pkgs/unified-theme-switcher {})
    ];
  };
}
