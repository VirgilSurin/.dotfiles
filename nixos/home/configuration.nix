{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../modules/common_config.nix
      inputs.home-manager.nixosModules.default
    ];

  commonConfig = {
    enable = true;
    hostname = "VS-Coruscant";
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
      firefox
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

  services.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };

  programs.steam = {
    enable = true;
  };

  system.stateVersion = "25.05"; # NEVER CHANGE THIS

}

