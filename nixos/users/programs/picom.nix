{ config, lib, pkgs, ... }:

{

  services.picom = {

    enable = true;
    package = pkgs.picom;
    backend = "xrender";

    fade = false;
    fadeSteps = [ 0.03 0.03 ];
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
      "80:class_g     = 'Polybar'"
      "100:class_g    = 'code-oss'"
      "100:class_g    = 'Meld'"
      "70:class_g     = 'TelegramDesktop'"
      "90:class_g     = 'Joplin'"
      "100:class_g    = 'firefox'"
      "100:class_g    = 'Thunderbird'"
    ];

    shadow = true;
    shadowOffsets = [ (-3) (-3) ];
    shadowOpacity = 0.6;
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
    };

    settings = {
      corner-radius = 0;
    };

  };

}
