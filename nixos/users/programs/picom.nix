{ config, lib, pkgs, ... }:

{

  services.picom = {

    enable = true;
    backend = "glx";

    fade = false;
    inactiveOpacity = 1.0;
    activeOpacity = 1.0;
    menuOpacity = 1.0;

    shadow = false;

  };

}
