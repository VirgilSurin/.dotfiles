{ config, lib, pkgs, ... }:

{

  services.picom = {

    enable = false;
    package = pkgs.picom-pijulius;
    backend = "glx";

    fade = false;
    fadeSteps = [ 0.01 0.1 ];
    fadeExclude = [
      "class_g = 'slop'"
    ];

    inactiveOpacity = 1.0;
    activeOpacity = 1.0;
    menuOpacity = 1.0;
    opacityRules = [
      "80:class_g     = 'Bar'"
      "100:class_g    = 'slop'"
      "100:class_g    = 'XTerm'"
      "100:class_g    = 'URxvt'"
      "100:class_g    = 'kitty'"
      "100:class_g    = 'Alacritty'"
      "100:class_g    = 'code-oss'"
      "100:class_g    = 'Meld'"
      "100:class_g    = 'firefox'"
      "100:class_g    = 'Thunderbird'"
    ];

    shadow = true;
    shadowOffsets = [ (-3) (-3) ];
    shadowOpacity = 0.3;
    shadowExclude = [
      "name = 'Notification'"
      "class_g = 'Conky'"
      "class_g ?= 'Notify-osd'"
      "class_g = 'Cairo-clock'"
      "class_g = 'slop'"
      "class_g = 'Polybar'"
      "class_g = 'trayer'"
      "override_redirect = true"
      "_GTK_FRAME_EXTENTS@:c"
    ];

    wintypes = {
      normal = { fade = false; shadow = true; };
      tooltip = { fade = true; shadow = true; opacity = 0.75; focus = true; full-shadow = false; };
      dock = { shadow = false; };
      dnd = { shadow = true; };
      popup_menu = { opacity = 1.0; };
      dropdown_menu = { opacity = 1.0; };

      notification = {
        animation = "slide-left";
        animation-unmap = "zoom";
      };
    };

    settings = {
      corner-radius = 0;
      animations = [
        {
          triggers = [ "open" "show" ];
          preset = "fly-in";
          direction = "left";
          duration = 0.5;
        }
        {
          triggers = [ "close" "hide" ];
          preset = "fly-out";
          direction = "right";
          duration = 0.3;
        }
      ];
    };

  };

}
