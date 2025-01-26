{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.monitor-switcher;
in {
  options.services.monitor-switcher = {
    enable = mkEnableOption "monitor switcher menu";

    profiles = mkOption {
      type = types.listOf types.str;
      default = [ "laptop" "home" "common" ];
      description = "List of autorandr profiles to include in the menu";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.writeScriptBin "monitor-switch" ''
    #!${pkgs.bash}/bin/bash
    # Pass the profiles from the config
    options=$(printf '%s\n' ${builtins.toString cfg.profiles})
    chosen=$(echo "$options" | ${pkgs.rofi}/bin/rofi -dmenu -i -p "Select Monitor Layout")

    if [ -n "$chosen" ]; then
      ${pkgs.autorandr}/bin/autorandr --load "$chosen"
    fi
  '';
      description = "The monitor switcher script package";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      pkgs.rofi
      pkgs.autorandr
    ];

  };
}
