{ config, lib, pkgs, inputs, ... }:

let
  startScript = pkgs.pkgs.writeShellScriptBin "start" ''
      ${pkgs.swww}/bin/swww-daemon &
      sleep 2
      ${pkgs.swww}/bin/swww img ${../../../wallpapers/star-wars-naboo-wallpapers.png} &
      ${pkgs.swww}/bin/swww init &
    '';
in
{

  imports = [
    ../modules/wallpaper.nix
  ];

  wallpaper = ../../../wallpapers/star-wars-naboo-wallpapers.png;

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      pkgs.hyprlandPlugins.hy3
    ];


  };
}
