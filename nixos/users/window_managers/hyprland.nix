{ config, lib, pkgs, inputs, ... }:

let
  startScript = pkgs.pkgs.writeShellScriptBin "start" ''
      ${pkgs.swww}/bin/swww-daemon &
      sleep 2
      ${pkgs.swww}/bin/swww img ${../../../wallpapers/star-wars-naboo-wallpapers.png} &
      ${pkgs.swww}/bin/swww init &
    '';
in
{

  imports = [
    inputs.hyprland.homeManagerModules.default
    ../modules/monitors.nix
    ../modules/wallpaper.nix
  ];

  wallpaper = ../../../wallpapers/star-wars-naboo-wallpapers.png;

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = 0;
      y = 0;
    }
    #{
     # name = "HDMI-A-1";
      #width = 1920;
      #height = 1080;
      #refreshRate = 60;
      #x = 0;
      #y = 0;
    #
   {
      name = "HDMI-A-1";
      width = 0;
      height = 0;
      refreshRate = 0;
      x = -1;
      y = -1;
    }
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      inputs.hy3.packages.x86_64-linux.hy3
    ];

    settings = {
      exec-once = [
        "waybar"
        "${pkgs.bash}/bin/bash ${startScript}/bin/start"
      ];

      monitor = map
        (m:
          let
            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position = "${toString m.x}x${toString m.y}";
          in
            "${m.name},${if m.enabled then "${if m.width > 0 then resolution else "preferred"},${if m.x >= 0 then "auto" else "auto-left"},1" else "disable"}"
        )
        (config.monitors);

      input = {
        kb_layout = "us";
        # kb_variant = ",qwerty";
        kb_options = "compose:ralt,ctrl:nocaps";
        numlock_by_default = true;
        accel_profile = "flat";

        follow_mouse = 2;

        touchpad = {
          natural_scroll = true;
        };

        sensitivity = 1;
      };

      general = {
        gaps_in = 8;
        gaps_out = 10;
        border_size = 3;
        "col.active_border" = "rgba(${config.colorScheme.palette.base0D}ff)";
        "col.inactive_border" = "rgba(${config.colorScheme.palette.base01}ff)";
        layout = "dwindle";
        cursor_inactive_timeout = 1;
        no_cursor_warps = true;
      };

      decoration = {
        rounding = 0;
        blur = {
          enabled = true;
          size = 8;
          passes = 1;
          noise = 0;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = true;
        bezier = [
          "pace, 0.46, 1, 0.29, 0.99"
          "overshot, 0.13, 0.99, 0.29, 1.1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "windowsMove, 1, 6, md3_decel, slide"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
          "border, 1, 10, default"
          "layers, 1, 7, md3_decel, slide"
        ];
      };

      windowrule = [
        "opacity 0.95, zathura"
      ];

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
        # tab_bar_height = 5;            # Sets the height of the tab bar in pixels
        # tab_bar_padding = 5;            # Sets the padding around the tab bar in pixels
        # tab_bar_font_size = 10;         # Sets the font size of the text in the tab bar
        # tab_bar_active_color = "rgba(${config.colorScheme.palette.base0A}ff)";  # Sets the background color of the active tab
        # tab_bar_inactive_color = "rgba(${config.colorScheme.palette.base01}ff)"; # Sets the background color of inactive tabs
        # tab_bar_border_color = "rgba(${config.colorScheme.palette.base0A}ff)";  # Sets the color of the border around the tab bar
        # tab_bar_text_color = "rgba(${config.colorScheme.palette.base01}ff)";   # Sets the color of the text in the tab bar
      };

      master = {
        new_is_master = true;
      };

      group = {
        "col.border_active" = "rgba(${config.colorScheme.palette.base09}ff)";
        "col.border_inactive" = "rgba(${config.colorScheme.palette.base01}ff)";
        groupbar = {
          height = 0;
          render_titles = false;
          "col.active" = "rgba(${config.colorScheme.palette.base09}ff)";
          "col.inactive" = "rgba(${config.colorScheme.palette.base01}ff)";
        };
      };

      gestures = {
        workspace_swipe = false;
      };

      plugin = {
        hy3 = {
          tabs = {
            height = 8;
            padding = 6;
            render_text = false;
            "col.active" = "rgba(${config.colorScheme.palette.base0C}ff)";
            "col.inactive" = "rgba(${config.colorScheme.palette.base03}A0)";
          };

          autotile = {
            enable = true;
            trigger_width = 800;
            trigger_height = 500;
          };
        };
      };

      misc = {
        force_default_wallpaper = 0;
      };

      "$terminal" = "alacritty";
      "$editor" = "emacsclient -c -a 'emacs'";
      "$browser" = "firefox";
      "$fileManager" = "pcmanfm";

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod CTRL, Q, exit,"
        "$mainMod, m, exec, $fileManager"
        "$mainMod, e, exec, $editor"
        "$mainMod, b, exec, $browser"
        "$mainMod, space, fullscreen,"
        "$mainMod SHIFT, z, exec, grim -g \"$(slurp)\" | wl-copy"

        ",233, exec, brightessctl set +5%"
        ",232, exec, brightnessctl set 5%-"
        ",121, exec, pamixer -t" # mute sound F1


        "$mainMod SHIFT, Return, togglegroup"
        "$mainMod CONTROL, k, changegroupactive, f"
        "$mainMod CONTROL, j, changegroupactive, b"
        "$mainMod, P, swapsplit, # dwindle"
        "$mainMod, V, togglesplit, # dwindle"


        # Move focus with mainMod + arrow keys
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        "$mainMod SHIFT, h, movewindoworgroup, l"
        "$mainMod SHIFT, k, movewindoworgroup, u"
        "$mainMod SHIFT, j, movewindoworgroup, d"
        "$mainMod SHIFT, l, movewindoworgroup, r"

        "$mainMod, equal, resizeactive,10 0"
        "$mainMod, minus, resizeactive,-10 0"
        "$mainMod SHIFT, =, resizeactive,0 10"
        "$mainMod SHIFT, -, resizeactive,0 -10"

        # "$mainMod, z, hy3:makegroup, tab"
        # "$mainMod, x, hy3:changefocus, raise"
        # "$mainMod+SHIFT, z, hy3:changefocus, lower"
        # "$mainMod, c, hy3:expand, expand"
        # "$mainMod+SHIFT, c, hy3:expand, base"
        # "$mainMod, n, hy3:changegroup, opposite"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, a, focusworkspaceoncurrentmonitor, 1"
        "$mainMod, s, focusworkspaceoncurrentmonitor, 2"
        "$mainMod, d, focusworkspaceoncurrentmonitor, 3"
        "$mainMod, f, focusworkspaceoncurrentmonitor, 4"
        "$mainMod, u, focusworkspaceoncurrentmonitor, 5"
        "$mainMod, i, focusworkspaceoncurrentmonitor, 6"
        "$mainMod, o, focusworkspaceoncurrentmonitor, 7"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, a, movetoworkspace, 1, follow"
        "$mainMod SHIFT, s, movetoworkspace, 2, follow"
        "$mainMod SHIFT, d, movetoworkspace, 3, follow"
        "$mainMod SHIFT, f, movetoworkspace, 4, follow"
        "$mainMod SHIFT, u, movetoworkspace, 5, follow"
        "$mainMod SHIFT, i, movetoworkspace, 6, follow"
        "$mainMod SHIFT, o, movetoworkspace, 7, follow"

        "$mainMod CONTROL, a, movetoworkspace, 1"
        "$mainMod CONTROL, s, movetoworkspace, 2"
        "$mainMod CONTROL, d, movetoworkspace, 3"
        "$mainMod CONTROL, f, movetoworkspace, 4"
        "$mainMod CONTROL, u, movetoworkspace, 5"
        "$mainMod CONTROL, i, movetoworkspace, 6"
        "$mainMod CONTROL, o, movetoworkspace, 7"
        # Example special workspace (scratchpad)
        # $mainMod, S, togglespecialworkspace, magic
        # $mainMod SHIFT, S, movetoworkspace, special:magic
        # Scroll through existing workspaces with mainMod + scroll
        # $mainMod, mouse_down, workspace, e+1
        # $mainMod, mouse_up, workspace, e-1
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

    };
  };
}
