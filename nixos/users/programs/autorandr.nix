{ config, lib, pkgs, ... }:

{

  services.autorandr.enable = true;
  programs.autorandr = {
    enable = true;


  };
}
