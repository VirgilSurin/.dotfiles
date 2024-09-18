{pkgs, config, ...}:

{

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 8;
        margin-top = 4;
        margin-bottom = 4;
        margin-left = 6;
        margin-right = 6;
        modules-left =  ["image" "hyprland/workspaces" "hyprland/window"];

        modules-center = [];

        modules-right = ["cpu" "network" "battery" "pulseaudio" "clock"];

        "custom/spacer" = {
          format = " ";
        };

        "image" = {
          "path" = "${../../../wallpapers/nixos_icon.png}";
          "size" = 22;
        };

        "hyprland/workspaces" = {
          "active-only" = "false";
          "all-outputs" = "true";
          "format" = "{icon}";
          "format-icons" = {
            "1" = "";
            "2" = "󰖟";
            "3" = "󱔗";
            "4" = "";
            "5" = "";
            "6" = "";
            "default" = "";
            };
          "persistent-workspaces" = {
            "eDP-1" = [1 2 3 4 5 6];
            "HDMI-A-1" = [1 2 3 4 5 6];
          };
        };
        "hyprland/window" = {
          "max-length" = 200;
          "separate-outputs" = "true";
        };
        "cpu"= {
          "interval"=10;
          "format"="  {usage:02}%";
        };
        "network"= {
          "interface"= "wlp6s0";
          # "format"= "{ifname}";
          "format-wifi"= "  {signalStrength}%";
          # "format-ethernet"= "{ifname}  ";
          # "format-disconnected"= "  ";
          "tooltip-format"= "{ifname}";
          "tooltip-format-wifi"= "{essid}({signalStrength}%)";
          "tooltip-format-ethernet"= "{ifname}";
          "tooltip-format-disconnected"= "Disconnected";
          "max-length"= 50;
        };
        "battery"= {
          "format"= "󰁾 {capacity}% ({time})";
          "format-time" = "{H}h{M}";
          "format-plugged"= " {capacity}% ({time})";
        };
        "pulseaudio" = {
          "format" = "{icon}  {volume}%";
          "format-muted" = "";
          "format-icons" = [
            ""
          ];
        };
        "clock"= {
          "format"= "{:%d/%m   %R }";
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: JetBrains Mono Normal;
        font-size: 14;
        min-height: 0;
        padding: 0;
        margin: 0;
      }

      .modules-left {
        margin-left: 10px;
      }
      .modules-right {
        margin-right: 10px;
      }

      window#waybar {
        border-radius: 10px 10px 10px 10px;
        color: #${config.colorScheme.palette.base05};
        background: #${config.colorScheme.palette.base00};
      }

      #custom-spacercenter {
          background-color: #${config.colorScheme.palette.base00};
          border-color: #${config.colorScheme.palette.base00};
      }

      #workspaces {
          background: #${config.colorScheme.palette.base01};
          border-style: solid;
          border-width: 1px;
          border-color: #${config.colorScheme.palette.base04};
          border-radius: 10px 10px 10px 10px;
          margin-left: 5px;
          margin-right: 5px;
          margin-top: 4px;
          margin-bottom: 4px;
          padding-right: 4px;
          padding-left: 4px;
      }

      #workspaces button.empty {
          transition: none;
          color: #${config.colorScheme.palette.base05};
          background: transparent;
          border-bottom: 2px solid transparent;
          margin-left: 4px;
          margin-right: 4px;
          margin-top: 2px;
          margin-bottom: 2px;
      }

      #workspaces button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
      }
      #workspaces button {
          padding-left: 1px;
          padding-right: 1px;
          color: #${config.colorScheme.palette.base0C};
          background: transparent;
          margin-left: 2px;
          margin-right: 2px;
          border-bottom: 2px solid transparent;
      }

      #workspaces button.active {
          border-bottom: 2px solid #${config.colorScheme.palette.base0B};
      }

      /* Focused button but on inactive monitor */
      #workspaces button.visible:not(.active) {
          border-bottom: 2px solid #${config.colorScheme.palette.base08};
      }

      #window {
          border-radius: 2px;
          padding-left: 10px;
          padding-right: 10px;
      }

      window#waybar.empty #window {
          background-color: transparent;
      }

      #cpu {
          color: #${config.colorScheme.palette.base0A};
          border-bottom: 3px solid #${config.colorScheme.palette.base0A};
          border-radius: 0px 0px 0px 0px;
          padding-left: 2px;
          padding-right: 2px;
          margin-left: 4px;
          margin-right: 4px;
      }

      #network {
          color: #${config.colorScheme.palette.base08};
          border-bottom: 3px solid #${config.colorScheme.palette.base08};
          border-radius: 0px 0px 0px 0px;
          padding-left: 2px;
          padding-right: 2px;
          margin-left: 4px;
          margin-right: 4px;
      }

      #battery {
          color: #${config.colorScheme.palette.base0B};
          border-bottom: 3px solid #${config.colorScheme.palette.base0B};
          border-radius: 0px 0px 0px 0px;
          padding-left: 2px;
          padding-right: 2px;
          margin-left: 4px;
          margin-right: 4px;
      }

      #pulseaudio {
          color: #${config.colorScheme.palette.base0E};
          border-bottom: 3px solid #${config.colorScheme.palette.base0E};
          border-radius: 0px 0px 0px 0px;
          padding-left: 2px;
          padding-right: 2px;
          margin-left: 4px;
          margin-right: 4px;
      }

      #clock {
          color: #${config.colorScheme.palette.base0D};
          border-bottom: 3px solid #${config.colorScheme.palette.base0D};
          border-radius: 0px 0px 0px 0px;
          padding-left: 2px;
          padding-right: 2px;
          margin-left: 4px;
          margin-right: 4px;
      }

    '';
  };
}
