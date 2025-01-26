{ config, pkgs, inputs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../modules/monitor_switcher.nix
    ../modules/dvd-lockscreen
    inputs.home-manager.nixosModules.default
    # inputs.hosts.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true; 
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null;
  };

  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "VS-chimaera";

  # Configure network proxy if necessary networking.proxy.default }= 
  # "http://user:password@proxy:port/"; networking.proxy.noProxy = 
  # "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = pkgs.lib.mkForce false;

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # Select internationalisation properties.
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

  # Configure keymap in X11

  services = {
    libinput.enable = true;
    libinput.touchpad.naturalScrolling = true;

    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.variant = "altgr-intl";
      xkb.options = "caps:ctrl_modifier";

      windowManager.qtile = {
        enable = true;
        package = pkgs.qtile;
        extraPackages = p: with p; [ qtile-extras ];
      };
    };

    monitor-switcher = {
      enable = true;
      profiles = [ "laptop" "home" "common" ];
    };

    displayManager = {
      defaultSession = "qtile";
      autoLogin = {
        enable = true;
        user = "virgil";
      };

      sddm = {
        enable = true;
        wayland.enable = false;
      };
    };
  };

  programs.hyprland = {
    enable = false;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = false;
  };
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # Lock
  # programs.xss-lock = {
  #   enable = true;
  #   lockerCommand = "${pkgs.sddm}/bin/sddm";
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.power-profiles-daemon.enable = false;

  services.logind.extraConfig = "IdleAction=ignore";

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "power";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 40;
    };
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };


  # fingerprint auth !
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
    backupFileExtension = "backup";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "jetbrains-toolbox"
    "jetbrains.idea-ultimate"
    "jetbrains.pycharm-community"
    "discord"
    "slack"
    "keymapp"
  ];
  # nixpkgs.config.allowUnfreePredicate = _: true;
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    bolt
    discord
    jetbrains-toolbox
    jetbrains.pycharm-community
    jetbrains.idea-ultimate
    slack
    wget
    git
    neovim
    tlp
    home-manager
    vial
    via
    keymapp
    spotify

    # qt5
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtsvg
    libsForQt5.breeze-gtk
    libsForQt5.breeze-icons
  ];

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs;
  };

  services.dvd-lockscreen = {
    enable = true;
    speed = 3;
  };

  networking.stevenBlackHosts = {
    blockFakenews = false;
    blockGambling = false;
    blockPorn = true;
    blockSocial = false;
  };

  services.udev.packages = with pkgs; [
    vial
    via
  ];
  # I now use a ZSA keyboard, I must enable some udev rules for it
  hardware.keyboard.zsa.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
