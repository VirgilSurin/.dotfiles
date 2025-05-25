 {
  description = "Theme switcher for Hyprland and Waybar";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        theme-switcher = pkgs.callPackage ./theme-switcher.nix {};
      in
      {
        packages.default = theme-switcher;
        packages.theme-switcher = theme-switcher;

        apps.default = {
          type = "app";
          program = "${theme-switcher}/bin/theme-switcher";
        };
      });
}
