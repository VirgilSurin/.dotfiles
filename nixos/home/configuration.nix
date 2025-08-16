{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../modules/common_config.nix
      inputs.home-manager.nixosModules.default
      # inputs.stylix.nixosModules.stylix
    ];

  stylix = {
    enable = true;
    base16Scheme = {
      base00 = "#282c34";
      base01 = "#353b45";
      base02 = "#3e4451";
      base03 = "#545862";
      base04 = "#565264";
      base05 = "#abb2bf";
      base06 = "#b6bdca";
      base07 = "#c8ccd4";
      base08 = "#56b6c2";
      base09 = "#c678dd";
      base0A = "#e5c07b";
      base0B = "#98c379";
      base0C = "#d19a66";
      base0D = "#61afef";
      base0E = "#e06c75";
      base0F = "#be5046";
    };
    fonts = {
      sansSerif = {
        package = pkgs.nerd-fonts.ubuntu;
        name = "Ubuntu Nerd Font";
      };
      serif = {
        package = pkgs.nerd-fonts.ubuntu;
        name = "Ubuntu Nerd Font";
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
    };
  };

  commonConfig = {
    enable = true;
    hostname = "VS-Coruscant";
  };

  # for secure boot
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "altgr-intl";
    xkb.options = "caps:ctrl_modifier";
  };

  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  users.users.virgil = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Virgil Surin";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "virgil" = import ./home.nix;
    };
    backupFileExtension = "backup-$(date +%Y%m%d)";
  };

  environment.systemPackages = with pkgs; [
    minecraft
    discord
    spotify
    keymapp
    vim
    alacritty
    # emacs stuff
    git
    ripgrep
    coreutils
    fd
    cmake
    gnumake
    clang
    libtool
    libvterm
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.ubuntu
    nerd-fonts.jetbrains-mono
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    kate
    okular
    elisa
    kwrited
    spectacle
  ];

  services.tailscale = {
    enable = true;
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };

  programs.steam = {
    enable = true;
  };

  system.stateVersion = "25.05"; # NEVER CHANGE THIS

}

