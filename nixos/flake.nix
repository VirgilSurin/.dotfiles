{
  description = "my configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

  };
  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86-64-linux";
      pkgs = import nixpkgs {
        config = {
          allowUnfree = true;
        };
      };
    in
      {
        nixosConfigurations = {
          virgil = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [
              ./users/virgil/configuration.nix
              inputs.home-manager.nixosModules.default
            ];
          };
        };
      };
}
