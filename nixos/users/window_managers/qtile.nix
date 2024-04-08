{ config, lib, pkgs, ... }:

{

  home.file.".dotfiles/qtile/themes.py".text = ''
Theme = {
    "bg":      "#${config.colorScheme.palette.base00}",
    "fg":      "#${config.colorScheme.palette.base05}",
    "black":   "#${config.colorScheme.palette.base02}",
    "white":   "#${config.colorScheme.palette.base06}",
    "red":     "#${config.colorScheme.palette.base0E}",
    "green":   "#${config.colorScheme.palette.base0D}",
    "orange":  "#${config.colorScheme.palette.base0C}",
    "blue":    "#${config.colorScheme.palette.base08}",
    "magenta": "#${config.colorScheme.palette.base09}",
    "cyan":    "#${config.colorScheme.palette.base0B}",
    "purple":  "#${config.colorScheme.palette.base0A}"
             }
'';

}
