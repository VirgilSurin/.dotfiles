{ config, lib, pkgs, ... }:

{
  options = {
    wallpaper = lib.mkOptions {
      default = ../../../wallpapers/ign_sunGarden.png;
      type = lib.types.path;
      description = ''
        Path to your wallpaper
      '';
    };
  };

  config = {
    home.file."setWallpaper.sh".source =
      let
        script = pkgs.writeShellScriptBin "setWallpaper.sh" ''
          ${pkgs.swww}/bin/swww img ${config.wallpaper}
        '';
      in
        "${script}/bin/setWallpaper.sh";
  };
}
