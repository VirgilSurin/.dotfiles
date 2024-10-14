{
  description = "my configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
    stylix.url = "github:danth/stylix";

    hosts.url = github:StevenBlack/hosts;

    hyprland.url = "github:hyprwm/Hyprland/d20ee312108d0e7879011cfffa3a83d06e48d29e";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.40.0"; # where {version} is the hyprland release version
      # or "github:outfoxxed/hy3" to follow the development branch.
      # (you may encounter issues if you dont do the same for hyprland)
      inputs.hyprland.follows = "hyprland";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86-64-linux";
    in
      {
        nixosConfigurations = {
          virgil = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [
              ./users/virgil/configuration.nix
              inputs.home-manager.nixosModules.default
              # inputs.stylix.nixosModules.stylix
              inputs.hosts.nixosModule {
                networking.stevenBlackHosts.enable = true;
              }
            ];
          };
        };
      };
}
