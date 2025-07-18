{ config, lib, pkgs, ... }:

let
  cfg = config.commonConfig;
in
{
  options.commonConfig = {
    enable = lib.mkEnableOpion "enable common config module";

    hostname = lib.mkOption {
      default = "VS-generic-name";
      description = ''
        Hostname for the machine
      '';
    };
  };

  config = lib.mkIf config.commonConfig.enable {
    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true;
        device = "nodev";
      };
    };

    networking.hostName = "${cfg.hostname}";
    networking.networkmanager.enable = true;

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
  };

  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.variant = "altgr-intl";
      xkb.options = "caps:ctrl_modifier";
    };

    printing.enable = true;

    pipewire = {
      enable = true;
    };
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
  };

  services.udev.packages = with pkgs; [
    vial
    via
  ];
  hardware.keyboard.zsa.enable = true;

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  hardware.bluetooth.enable = true;

}
