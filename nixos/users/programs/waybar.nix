{pkgs, config, ...}:

{

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left =  ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["cpu" "memory" "network" "battery"];
        "cpu"= {
          "interval"=10;
          "format"="{usage:02}%   ";
        };
        "memory" = {
          "interval" = 10;
          "format" = "{}%   ";
        };
        "network"= {
          "interface"= "wlp6s0";
          # "format"= "{ifname}";
          "format-wifi"= "{essid}   ";
          # "format-ethernet"= "{ifname}  ";
          # "format-disconnected"= "  ";
          "tooltip-format"= "{ifname}";
          "tooltip-format-wifi"= "{essid}({signalStrength}%)";
          "tooltip-format-ethernet"= "{ifname}  ";
          "tooltip-format-disconnected"= "Disconnected";
          "max-length"= 50;
        };
        "battery"= {
          "format"= "{capacity}% 󰁾";
          "format-plugged"= "{capacity}% ";
        };
        "clock"= {
          "format"= "{:%R    %d/%m  }";
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: JetBrainsMono Nerd Font;
        font-size: 15px;
        min-height: 0;
      }

      .modules-right {
        margin-right: 10px;
      }

      window#waybar {
        color: #${config.colorScheme.palette.base06};
        background: #${config.colorScheme.palette.base01};
        border-bottom: 3px solid #${config.colorScheme.palette.base00};
      }

      #workspaces button {
        padding: 0 5px;
        background: transparent;
        color: #${config.colorScheme.palette.base06};
      }

      #workspaces button.active {
        color: #${config.colorScheme.palette.base04};
      }

      #workspaces button.urgent {
        color: #${config.colorScheme.palette.base08};
      }
    '';
  };
}
