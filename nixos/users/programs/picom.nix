{ config, lib, pkgs, ... }:

{

  services.picom = {

    enable = true;
    backend = "glx";

    fade = true;
    fadeSteps = [
      0.03
      0.03
    ];

    inactiveOpacity = 0.98;
    activeOpacity = 1.0;
    menuOpacity = 1.0;

    shadow = true;

    wintypes = {
      normal = { fade = false; shadow = false; };
      tooltip = { fade = true; shadow = false; opacity = 0.75; focus = true; full-shadow = false; };
      dock = { shadow = false; };
      dnd = { shadow = false; };
      popup_menu = { opacity = 1.0; };
      dropdown_menu = { opacity = 1.0; };
    };

    settings = {
      blur = {
        method = "gaussian";
        size = 5;
        deviation = 9.0;
      };
    };
  };

}
