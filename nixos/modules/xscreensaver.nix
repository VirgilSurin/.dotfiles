{ config, lib, pkgs, ... }:

{
  services.xscreensaver = {
    enable = true;
    settings = {
      timeout = "0:10:00";
      lock = true;
      lockTimeout = "0:00:30";
      passwdTimeout = "0:00:30";
      fade = false;
      unfade = false;
      fadeSeconds = "0:00:03";
      fadeTicks = 20;
      splash = false;
      dpmsEnabled = false;
      mode = "one";
      selected = 0;  # Select the first program (our video)
      programs = ''
        mpv --really-quiet --no-audio --fs --loop=inf --no-stop-screensaver --wid=$XSCREENSAVER_WINDOW $HOME/.config/hypr/dvd.webm
      '';
    };
  };
}
