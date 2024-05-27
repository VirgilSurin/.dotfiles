{ config, lib, pkgs, ... }:

{

  wayland.windowManager.hyprland = {
    settings = {
      bindr = [ "$mainMod, r, exec, wofi" ];
    };
  };

  programs.wofi = {
    enable = true;

    settings = {
      width = 500;
      height = 500;
      location = "center";
      show = "drun";
      prompt = "";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
      sort_order = "alphabetical";
    };

    style = ''
      * {
        font-family:  JetBrains Mono SemiBold;
        font-size: 16px;
        font-weight: 400;
        outline-style: none;
      }

      #window {
        margin: 0px;
        border: 2px solid;
        border-color: #${config.colorScheme.palette.base0D};
        border-radius: 12px;
        background-color: #${config.colorScheme.palette.base00};
      }

      #input {
        margin: 16px;
        background-color: #${config.colorScheme.palette.base00};
        color: #${config.colorScheme.palette.base04};
        border-radius: 25px;
        border: transparent;
      }

      #scroll {
        margin-bottom: 2px;
        margin-right: 2px;
      }

      #entry {
        margin: 0px 4px;
      }

      #entry:selected {
        background-color: #${config.colorScheme.palette.base04};
        border-radius: 8px;
      }

      #entry > box {
        margin-left: 0px;
        color: #dedede;
      }

      #entry image {
        padding-right: 10px;
        background-color: transparent;
      }

      #text {
        background-color:transparent;
      }
    '';
  };
}
