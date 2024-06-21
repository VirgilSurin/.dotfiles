{ config, lib, pkgs, ... }:

{

  programs.zathura = {
    enable = true;
    options = {
      default-bg = "#${config.colorScheme.palette.base00}";
      default-fg = "#${config.colorScheme.palette.base05}";
      recolor-darkcolor = "#${config.colorScheme.palette.base05}";
      recolor-lightcolor = "#${config.colorScheme.palette.base01}";

      statusbar-bg = "#${config.colorScheme.palette.base01}";
      statusbar-fb = "#${config.colorScheme.palette.base05}";
    };
  };

}
