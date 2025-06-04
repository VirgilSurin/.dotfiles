{ config, lib, pkgs, ... }:

{
  theme-switcher = pkgs.callPackage ./theme-switcher/theme-switcher.nix {};
  i3-lock = pkgs.callPackage ./custom-i3lock/default.nix {};
}
