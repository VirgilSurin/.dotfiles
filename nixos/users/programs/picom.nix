{ config, lib, pkgs, ... }:

{

  services.picom = {

    enable = true;
    backend = "glx";

    fade = true;
    fadeDelta = 10;

    opacityRules = [
      "100:class_g = 'URxvt'"
      "90:class_g = 'Emacs'" # Adjust the value for desired transparency
      # "100:class_g = 'Alacritty'"
    ];

    settings = {
      blur = {
        method = "gaussian";
        size = 5;
        deviation = 9.0;
      };
    };
  };

}
