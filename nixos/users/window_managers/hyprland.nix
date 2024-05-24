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

      monitor=",preferred,auto,1";

      input = {
        kb_layout = "us";
        kb_options = "ctrl:nocaps";
        numlock_by_default = true;
        accel_profile = "flat";

        follow_mouse = 2;

        touchpad = {
          natural_scroll = true;
        };

        sensitivity = 1;
      };

      general = {
        gaps_in = 10;
        gaps_out = 16;
        border_size = 3;
        "col.active_border" = "rgba(${config.colorScheme.palette.base0D}ff)";
        "col.inactive_border" = "rgba(${config.colorScheme.palette.base01}ff)";
        layout = "hy3";
      };

      decoration = {
        rounding = 2;
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
        ];
        animation = [
          "windowsIn, 1, 6, md3_decel, slide"
          "windowsOut, 1, 6, md3_decel, slide"
          "windowsMove, 1, 6, md3_decel, slide"
          "fade, 1, 10, md3_decel"
          "workspaces, 1, 7, md3_decel, slide"
          "border, 0, 3, md3_decel"
          "layers, 1, 7, md3_decel, slide"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_is_master = true;
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
        "$mainMod, space, togglefloating,"
        # "$mainMod, P, swapsplit, # dwindle"
        # "$mainMod, V, togglesplit, # dwindle"

        ",233, exec, brightessctl set +5%"
        ",232, exec, brightnessctl set 5%-"
        ",121, exec, pamixer -t" # mute sound F1


        "$mainMod SHIFT, Return, hy3:makegroup, tab"
        "$mainMod CONTROL, j, hy3:changefocus, lower"
        "$mainMod CONTROL, k, hy3:changefocus, raise"

        # Move focus with mainMod + arrow keys
        "$mainMod, h, hy3:movefocus, l, visible, nowarp"
        "$mainMod, l, hy3:movefocus, r, visible, nowarp"
        "$mainMod, k, hy3:movefocus, u, visible, nowarp"
        "$mainMod, j, hy3:movefocus, d, visible, nowarp"

        "$mainMod SHIFT, h, hy3:movewindow, l"
        "$mainMod SHIFT, j, hy3:movewindow, d"
        "$mainMod SHIFT, k, hy3:movewindow, u"
        "$mainMod SHIFT, l, hy3:movewindow, r"

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
        "$mainMod, a, workspace, 1"
        "$mainMod, s, workspace, 2"
        "$mainMod, d, workspace, 3"
        "$mainMod, f, workspace, 4"
        "$mainMod, u, workspace, 5"
        "$mainMod, i, workspace, 6"
        "$mainMod, o, workspace, 7"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, a, hy3:movetoworkspace, 1, follow"
        "$mainMod SHIFT, s, hy3:movetoworkspace, 2, follow"
        "$mainMod SHIFT, d, hy3:movetoworkspace, 3, follow"
        "$mainMod SHIFT, f, hy3:movetoworkspace, 4, follow"
        "$mainMod SHIFT, u, hy3:movetoworkspace, 5, follow"
        "$mainMod SHIFT, i, hy3:movetoworkspace, 6, follow"
        "$mainMod SHIFT, o, hy3:movetoworkspace, 7, follow"

        "$mainMod CONTROL, a, hy3:movetoworkspace, 1"
        "$mainMod CONTROL, s, hy3:movetoworkspace, 2"
        "$mainMod CONTROL, d, hy3:movetoworkspace, 3"
        "$mainMod CONTROL, f, hy3:movetoworkspace, 4"
        "$mainMod CONTROL, u, hy3:movetoworkspace, 5"
        "$mainMod CONTROL, i, hy3:movetoworkspace, 6"
        "$mainMod CONTROL, o, hy3:movetoworkspace, 7"
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
