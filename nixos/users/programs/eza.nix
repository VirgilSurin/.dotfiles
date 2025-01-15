{ config, lib, pkgs, ... }:

{
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration  = true;
    git = true;
    icons = true;
    extraOptions = [
      "--icons"
      "--group-directories-first"
      "--header"
    ];
  };
}
