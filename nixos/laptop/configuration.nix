{ config, pkgs, inputs, lib, fetchFromGitHub, unstable, ... }:

{
  nixpkgs.overlays = builtins.attrValues inputs.self.overlays;

  imports = [
    ./hardware-configuration.nix
    ../modules/common_config.nix
    inputs.home-manager.nixosModules.default
    inputs.stylix.nixosModules.stylix
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
    hostname = "VS-Chimaera";
  };

  boot.initrd.secrets = { "/crypto_keyfile.bin" = null;
                        };

  services = {
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;

      mouse = {
        accelProfile = "flat";
        accelSpeed = "0.0";
      };
    };

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
