{ config, lib, pkgs, ... }:

{
  home.file.".config/qtile/config.py".source = ./users/window_managers/qtile/config.py;
}
