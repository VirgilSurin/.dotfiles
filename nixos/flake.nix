{
  description = "my configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nvf = {
    #   url = "github:notashelf/nvf";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # Need to wait till they update things I guess

    nix-colors.url = "github:misterio77/nix-colors";

    hosts.url = "github:StevenBlack/hosts";

  };
  outputs = { self, nixpkgs, ... }@inputs:
      {
        nixosConfigurations = {
          virgil = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [
              ./users/virgil/configuration.nix
              inputs.home-manager.nixosModules.default
              inputs.hosts.nixosModule {
                networking.stevenBlackHosts.enable = true;
              }
            ];
          };
        };
      };
}
