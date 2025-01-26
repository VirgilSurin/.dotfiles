# modules/dvd-lockscreen/default.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dvd-lockscreen;
in {
  options.services.dvd-lockscreen = {
    enable = mkEnableOption "DVD logo lockscreen";
    speed = mkOption {
      type = types.int;
      default = 2;
      description = "Animation speed";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.callPackage ./package.nix { inherit (cfg) speed; })
    ];

    security.pam.services.dvd-lockscreen = {};

    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.xorg.xhost}/bin/xhost +SI:localuser:$USER
    '';
  };
}
