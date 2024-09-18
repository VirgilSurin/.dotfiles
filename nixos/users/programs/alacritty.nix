{ config, pkgs, ... }:

{

  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 10;
      colors.draw_bold_text_with_bright_colors = true;
      window = {
        opacity = 0.95;
      };
      colors = {
         primary = {
           background = "#${config.colorScheme.palette.base00}";
           foreground= "#${config.colorScheme.palette.base05}";
         };
         normal = {
           black  = "#${config.colorScheme.palette.base00}";
           red    = "#${config.colorScheme.palette.base0E}";
           green  = "#${config.colorScheme.palette.base0D}";
           yellow = "#${config.colorScheme.palette.base0A}";
           blue   = "#${config.colorScheme.palette.base08}";
           magenta= "#${config.colorScheme.palette.base09}";
           cyan   = "#${config.colorScheme.palette.base0B}";
           white  = "#${config.colorScheme.palette.base06}";
         };
         bright = {
           black  = "#${config.colorScheme.palette.base00}";
           red    = "#${config.colorScheme.palette.base0E}";
           green  = "#${config.colorScheme.palette.base0D}";
           yellow = "#${config.colorScheme.palette.base0A}";
           blue   = "#${config.colorScheme.palette.base08}";
           magenta= "#${config.colorScheme.palette.base09}";
           cyan   = "#${config.colorScheme.palette.base0B}";
           white  = "#${config.colorScheme.palette.base06}";
         };
      };
    };
  };
}
