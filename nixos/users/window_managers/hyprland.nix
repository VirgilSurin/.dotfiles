{ config, lib, pkgs, ... }:

let
  startupScript = pkgs.writeScriptBin "start" ''
  #!pkgs.stdenv.shell
  ${pkgs.waybar}/bin/waybar &
  ${pkgs.swww}/bin/swww init &

  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = ''${startupScript}/bin/start'';
    };
  };
}
