{ pkgs }:

{
  theme-switcher = pkgs.callPackage ./theme-switcher/theme-switcher.nix {};
  custom-i3lock = pkgs.callPackage ./custom-i3lock/default.nix {};
}
