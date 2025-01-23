{ config, lib, pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      name = "plata-theme";
      package = pkgs.plata-theme;
    };
  };
}
