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
    ../modules/wallpaper.nix
  ];

  wallpaper = ../../../wallpapers/star-wars-naboo-wallpapers.png;

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = [
        "waybar"
        "${pkgs.bash}/bin/bash ${startScript}/bin/start"
      ];
      monitor = [
        # Format: name,resolution,position,scale
        ",preferred,auto,1"
      ];
      # monitor = map
      #   (m:
      #     let
      #       resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
      #       position = "${toString m.x}x${toString m.y}";
      #     in
      #       "${m.name},${if m.enabled then "${if m.width > 0 then resolution else "preferred"},${if m.x >= 0 then "auto" else "auto-left"},1" else "disable"}"
      #   )
      #   (config.monitors);

      input = {
        kb_layout = "us,us";
        kb_variant = ",colemak_dh";
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
        gaps_in = 4;
        gaps_out = 4;
        border_size = 3;
        "col.active_border" = "rgba(${config.colorScheme.palette.base0D}ff)";
        "col.inactive_border" = "rgba(${config.colorScheme.palette.base01}ff)";
        layout = "dwindle";
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
          "snappy, 0.05, 0.1, 0.1, 1.0"
          "quickOut, 0.25, 0.2, 0.5, 1.0"
          "instant, 0.7, 0.0, 1.0, 1.0"
          "snap, 0.85, 0, 0.15, 1"
        ];
        animation = [
          "windows, 1, 3, snappy"
          "windowsOut, 1, 3, instant, popin 80%"
          "windowsMove, 1, 3, snap, slide"
          "fade, 1, 3, instant"
          "workspaces, 1, 2, snap"
          "border, 1, 1, instant"
          "layers, 1, 3, snap, slide"
        ];
      };


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

      misc = {
        force_default_wallpaper = 0;
      };

      "$terminal" = "alacritty";
      "$editor" = "emacsclient -c -a 'emacs'";
      "$browser" = "firefox";
      "$fileManager" = "dolphin";

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod CTRL, Q, exit,"
        "$mainMod, m, exec, $fileManager"
        "$mainMod, x, exec, $editor"
        "$mainMod, b, exec, $browser"
        "$mainMod, space, fullscreen,"
        "$mainMod SHIFT, z, exec, grim -g \"$(slurp)\" | wl-copy"
        "$mainMod, Z, exec, mpv --fullscreen --no-audio --loop --no-osc ~/.config/hypr/dvd.webm"
        "$mainMod CTRL, Z, exec, hyprlock"
        ",233, exec, brightessctl set +5%"
        ",232, exec, brightnessctl set 5%-"
        ",121, exec, pamixer -t" # mute sound F1


        "$mainMod SHIFT, Return, togglegroup"
        "$mainMod CONTROL, i, changegroupactive, f"
        "$mainMod CONTROL, e, changegroupactive, b"
        "$mainMod, C, swapsplit, # dwindle"
        "$mainMod, V, togglesplit, # dwindle"


        # Move focus with mainMod + arrow keys
        "$mainMod, n, movefocus, l"
        "$mainMod, e, movefocus, d"
        "$mainMod, i, movefocus, u"
        "$mainMod, o, movefocus, r"

        "$mainMod SHIFT, n, movewindoworgroup, l"
        "$mainMod SHIFT, e, movewindoworgroup, d"
        "$mainMod SHIFT, i, movewindoworgroup, u"
        "$mainMod SHIFT, o, movewindoworgroup, r"

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
        "$mainMod, r, focusworkspaceoncurrentmonitor, 2"
        "$mainMod, s, focusworkspaceoncurrentmonitor, 3"
        "$mainMod, t, focusworkspaceoncurrentmonitor, 4"
        "$mainMod, l, focusworkspaceoncurrentmonitor, 5"
        "$mainMod, u, focusworkspaceoncurrentmonitor, 6"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, a, movetoworkspace, 1, follow"
        "$mainMod SHIFT, r, movetoworkspace, 2, follow"
        "$mainMod SHIFT, s, movetoworkspace, 3, follow"
        "$mainMod SHIFT, s, movetoworkspace, 4, follow"
        "$mainMod SHIFT, l, movetoworkspace, 5, follow"
        "$mainMod SHIFT, u, movetoworkspace, 6, follow"

        "$mainMod CONTROL, a, movetoworkspace, 1"
        "$mainMod CONTROL, r, movetoworkspace, 2"
        "$mainMod CONTROL, s, movetoworkspace, 3"
        "$mainMod CONTROL, t, movetoworkspace, 4"
        "$mainMod CONTROL, l, movetoworkspace, 5"
        "$mainMod CONTROL, u, movetoworkspace, 6"
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
