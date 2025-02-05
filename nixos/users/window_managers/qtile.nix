{ config, lib, pkgs, ... }:

{
  home.file.".config/qtile/config.py".source = ./users/window_managers/qtile/config.py;
  home.file.".config/qtile/themes.py".source = ./users/window_managers/qtile/themes.py;
}
