{ config, lib, pkgs, ... }:

{
  programs.kde = {
    enable = true;
    style = {
      name = "breeze-dark";
      package = pkgs.breeze;
    };
  };
}
