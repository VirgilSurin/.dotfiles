{ config, pkgs, inputs, lib, fetchFromGitHub, ... }:

{
  nixpkgs.overlays = builtins.attrValues inputs.self.overlays;

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../modules/monitor_switcher.nix
    inputs.home-manager.nixosModules.default
    inputs.nix-colors.homeManagerModules.default
    # inputs.hosts.nixosModules.default
  ];

  colorScheme = inputs.nix-colors.colorSchemes.onedark;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.secrets = { "/crypto_keyfile.bin" = null;
  };

  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "VS-chimaera";
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = pkgs.lib.mkForce false;

  time.timeZone = "Europe/Brussels";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_BE.UTF-8";
    LC_IDENTIFICATION = "fr_BE.UTF-8";
    LC_MEASUREMENT = "fr_BE.UTF-8";
    LC_MONETARY = "fr_BE.UTF-8";
    LC_NAME = "fr_BE.UTF-8";
    LC_NUMERIC = "fr_BE.UTF-8";
    LC_PAPER = "fr_BE.UTF-8";
    LC_TELEPHONE = "fr_BE.UTF-8";
    LC_TIME = "fr_BE.UTF-8";
  };

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "virgil" ];

  services.hardware.bolt.enable = true;

  services = {
    libinput.enable = true;
    libinput.touchpad.naturalScrolling = true;

    xserver = {
      enable = true;
      xkb = {
        layout = "us,us";
        variant = "altgr-intl,colemak_dh";
        options = "caps:ctrl_modifier";
      };

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      windowManager.qtile = {
        enable = true;
        package = pkgs.qtile;
        extraPackages = p: with p; [ qtile-extras iwlib dbus-fast ];
      };

      desktopManager.gnome.enable = false;
    };

    monitor-switcher = {
      enable = true;
      profiles = [ "laptop" "home" "mobile-portrait" "common" ];
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

  services.printing.enable = true;

  services.power-profiles-daemon.enable = false;

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

  services.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = false;
    # jack.enable = true;
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  services.fprintd = {
    enable = false;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  };

  programs.steam.enable = false;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users = {
    users.virgil = {
      isNormalUser = true;
      shell = pkgs.zsh;
      description = "Virgil Surin";
      extraGroups = [ "audio" "networkmanager" "wheel" "video" "docker" ];
      packages = with pkgs; [
        firefox
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

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "keymapp"
  ];

  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  environment.systemPackages = with pkgs; [
    discord
    slack
    wget
    git
    neovim
    tlp
    home-manager
    keymapp
    spotify

    libdrm
    mesa
    wayland
    libxkbcommon
    pixman
    libinput
    seatd
    wlroots

    # for usb
    usbutils
    udiskie
    udisks

    # qt5
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtsvg
    libsForQt5.breeze-gtk
    libsForQt5.breeze-icons
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

  services.udev.packages = with pkgs; [
    vial
    via
  ];
  hardware.keyboard.zsa.enable = true;

  security.sudo.enable = true;
  security.doas = {
    enable = true;
    extraRules = [{
      users = [ "virgil" ];
      keepEnv = true;
      persist = true;
    }];
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

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;


  system.stateVersion = "23.05"; # DO NOT CHANGE

}
