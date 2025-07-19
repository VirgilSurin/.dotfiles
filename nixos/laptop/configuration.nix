{ config, pkgs, inputs, lib, fetchFromGitHub, unstable, ... }:

{
  nixpkgs.overlays = builtins.attrValues inputs.self.overlays;

  imports = [
    ./hardware-configuration.nix
    ../modules/common_config.nix
    inputs.home-manager.nixosModules.default
  ];

  commonConfig = {
    enable = true;
    hostname = "VS-Coruscant";
  };

  boot.initrd.secrets = { "/crypto_keyfile.bin" = null;
  };

  services = {
    libinput.enable = true;
    libinput.touchpad.naturalScrolling = true;

    xserver = {

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      windowManager.qtile = {
        enable = true;
        package = pkgs.qtile;
        extraPackages = p: with p; [ qtile-extras iwlib dbus-fast ];
      };
    };

    displayManager = {
      defaultSession = "qtile";
      autoLogin = {
        enable = false;
        user = "virgil";
      };

      sddm = {
        enable = false;
        wayland.enable = true;
        theme = "where_is_my_sddm_theme";
      };

    };
  };

  programs.hyprland = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    wlr = {
      enable = true;
    };
  };

  services.logind.extraConfig = "IdleAction=ignore";

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 40;
    };
  };

  security.rtkit.enable = true;

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  users = {
    users.virgil = {
      isNormalUser = true;
      shell = pkgs.zsh;
      description = "Virgil Surin";
      extraGroups = [ "audio" "networkmanager" "wheel" "video" "docker" ];
      packages = with pkgs; [
        brave
      ];
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "virgil" = import ./home.nix;
    };
  backupFileExtension = "backup-$(date +%Y%m%d)";
  };

  # nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #   "discord"
  #   "keymapp"
  # ];

  nix.settings = {
    substituters = [ "https://claude-code.cachix.org" ];
    trusted-public-keys = [ "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk=" ];
    trusted-users = [ "root" "virgil" ];
  };

  environment.systemPackages = with pkgs; [
    unstable.discord
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
    clang
    libtool
    libvterm
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.ubuntu
    nerd-fonts.jetbrains-mono
  ];

  qt = {
    enable = true;
    style = "adwaita-highcontrast";
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };

  networking.stevenBlackHosts = {
    blockFakenews = true;
    blockGambling = true;
    blockPorn = true;
    blockSocial = false;
  };

  security.pam.services = {
    i3lock = {
      enable = true;
    };
    i3lock-color = {
      enable = true;
    };
    xscreensaver = {
      enable = true;
    };
  };

  system.stateVersion = "23.05"; # DO NOT CHANGE

}
