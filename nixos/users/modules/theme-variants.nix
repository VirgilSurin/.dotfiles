# nixos/users/modules/theme-variants.nix
{ config, lib, pkgs, inputs, ... }:

let
  # Define all your themes here
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
    catppuccin = {
      scheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
      wallpaper = ../../../wallpapers/boat_painting.jpg;
    };
  };

  currentTheme = config.myTheme.current or "gruvbox";

  # Generate theme-specific configurations for each application
  generateAppConfig = themeName: themeData: {
    # Alacritty theme variant
    "alacritty/themes/${themeName}.toml" = {
      text = ''
        [colors.primary]
        background = "#${themeData.scheme.palette.base00}"
        foreground = "#${themeData.scheme.palette.base05}"

        [colors.normal]
        black = "#${themeData.scheme.palette.base03}"
        red = "#${themeData.scheme.palette.base0E}"
        green = "#${themeData.scheme.palette.base0D}"
        yellow = "#${themeData.scheme.palette.base0A}"
        blue = "#${themeData.scheme.palette.base08}"
        magenta = "#${themeData.scheme.palette.base09}"
        cyan = "#${themeData.scheme.palette.base0B}"
        white = "#${themeData.scheme.palette.base06}"

        [colors.bright]
        black = "#${themeData.scheme.palette.base03}"
        red = "#${themeData.scheme.palette.base0E}"
        green = "#${themeData.scheme.palette.base0D}"
        yellow = "#${themeData.scheme.palette.base0A}"
        blue = "#${themeData.scheme.palette.base08}"
        magenta = "#${themeData.scheme.palette.base09}"
        cyan = "#${themeData.scheme.palette.base0B}"
        white = "#${themeData.scheme.palette.base06}"

        [window]
        opacity = 1.0
        [window.padding]
        x = 6
        y = 6

        [font]
        size = 10

        [colors]
        draw_bold_text_with_bright_colors = true
      '';
    };

    # Rofi theme variant
    "rofi/themes/${themeName}.rasi" = {
      text = ''
        * {
          background-color: #${themeData.scheme.palette.base00};
          border-color: #${themeData.scheme.palette.base08};
          text-color: #${themeData.scheme.palette.base05};
          font: "FiraCodeNerdFontMono-Medium 12";
          prompt-background: #${themeData.scheme.palette.base08};
          prompt-foreground: #${themeData.scheme.palette.base00};
          alternate-normal-background: #${themeData.scheme.palette.base01};
          selected-normal-background: #${themeData.scheme.palette.base0D};
          selected-normal-foreground: #${themeData.scheme.palette.base00};
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
      '';
    };

    # Wofi theme variant
    "wofi/themes/${themeName}.css" = {
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

    # Dunst theme variant
    "dunst/themes/${themeName}.conf" = {
      text = ''
        [global]
        follow = keyboard
        offset = 10x34
        padding = 8
        horizontal_padding = 8
        frame_width = 2
        frame_color = "#${themeData.scheme.palette.base08}"
        font = JetbrainsMonoBold 12
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
        frame_color = "#${themeData.scheme.palette.base09}"
        timeout = 10
      '';
    };

    # Fish theme variant
    "fish/themes/${themeName}.fish" = {
      text = ''
        set -g fish_color_autosuggestion '#${themeData.scheme.palette.base03}'
        set -g fish_color_command '#${themeData.scheme.palette.base0D}'
        set -g fish_color_comment '#${themeData.scheme.palette.base03}'
        set -g fish_color_cwd '#${themeData.scheme.palette.base0B}'
        set -g fish_color_error '#${themeData.scheme.palette.base08}'
        set -g fish_color_param '#${themeData.scheme.palette.base05}'
        set -g fish_color_quote '#${themeData.scheme.palette.base0A}'
        set -g fish_color_redirection '#${themeData.scheme.palette.base0C}'
      '';
    };

    # Qtile theme variant
    "qtile/themes/${themeName}.py" = {
      text = ''
        ${themeName} = {
            "bg":      "#${themeData.scheme.palette.base00}",
            "fg":      "#${themeData.scheme.palette.base05}",
            "black":   "#${themeData.scheme.palette.base03}",
            "white":   "#${themeData.scheme.palette.base06}",
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

    # Emacs theme variant
    "emacs/themes/${themeName}-theme.el" = {
      text = ''
        ;;; ${themeName}-theme.el --- Auto-generated theme

        (require 'doom-themes)

        (def-doom-theme ${themeName}-auto
          "Auto-generated ${themeName} theme"

          ((bg         '("#${themeData.scheme.palette.base00}"))
           (bg-alt     '("#${themeData.scheme.palette.base01}"))
           (base02     '("#${themeData.scheme.palette.base02}"))
           (base03     '("#${themeData.scheme.palette.base03}"))
           (base04     '("#${themeData.scheme.palette.base04}"))
           (fg         '("#${themeData.scheme.palette.base05}"))
           (base06     '("#${themeData.scheme.palette.base06}"))
           (fg-alt     '("#${themeData.scheme.palette.base07}"))
           (base08     '("#${themeData.scheme.palette.base08}"))
           (base09     '("#${themeData.scheme.palette.base09}"))
           (base0A     '("#${themeData.scheme.palette.base0A}"))
           (base0B     '("#${themeData.scheme.palette.base0B}"))
           (base0C     '("#${themeData.scheme.palette.base0C}"))
           (base0D     '("#${themeData.scheme.palette.base0D}"))
           (base0E     '("#${themeData.scheme.palette.base0E}"))
           (base0F     '("#${themeData.scheme.palette.base0F}")))

          ())

        (provide '${themeName}-theme)
      '';
    };
  };

in {
  options.myTheme = {
    current = lib.mkOption {
      type = lib.types.str;
      default = "gruvbox";
      description = "Current theme name";
    };

    available = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = builtins.attrNames themes;
      description = "Available theme names";
    };
  };

  config = {
    # Set the colorScheme based on current theme
    colorScheme = themes.${currentTheme}.scheme;

    # Generate all theme variant files
    home.file = lib.mkMerge [
      (lib.mapAttrs' (themeName: themeData:
        lib.nameValuePair "theme-variants/${themeName}/wallpaper" {
          source = themeData.wallpaper;
        }
      ) themes)

      (lib.mkMerge (lib.mapAttrsToList (themeName: themeData:
        generateAppConfig themeName themeData
      ) themes))
    ];

    # Create active theme symlinks (these point to current theme)
    home.file."config/alacritty/alacritty.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/alacritty/themes/${currentTheme}.toml";

    home.file."config/rofi/config.rasi".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/rofi/themes/${currentTheme}.rasi";

    home.file."config/wofi/style.css".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/wofi/themes/${currentTheme}.css";

    home.file."config/dunst/dunstrc".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/dunst/themes/${currentTheme}.conf";

    home.file."config/fish/themes/current.fish".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/fish/themes/${currentTheme}.fish";

    home.file."config/qtile/current_theme.py".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/qtile/themes/${currentTheme}.py";

    # Create a theme info file
    home.file."config/theme-switcher/current-theme".text = currentTheme;
    home.file."config/theme-switcher/available-themes".text =
      builtins.concatStringsSep "\n" (builtins.attrNames themes);
  };
}
