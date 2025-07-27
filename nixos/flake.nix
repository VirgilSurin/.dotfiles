{
  description = "my configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "unstable";
    };

    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";

    hosts.url = "github:StevenBlack/hosts";
  };
  outputs = { self, nixpkgs, unstable, stylix, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
      };
      unstable-pkgs = import unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
      {

        overlays = import ./overlays {inherit inputs;};

        nixosConfigurations = {

          home = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs pkgs system; };
            modules = [
              ./home/configuration.nix
              stylix.nixosModules.stylix
              inputs.home-manager.nixosModules.default
            ];
          };

          laptop = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs pkgs system; unstable = unstable-pkgs; };
            modules = [
              ./laptop/configuration.nix
              inputs.home-manager.nixosModules.default
              stylix.nixosModules.stylix
              inputs.hosts.nixosModule {
                networking.stevenBlackHosts.enable = true;
              }
            ];
          };
        };
      };
}
