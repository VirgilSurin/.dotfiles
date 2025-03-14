{ pkgs, config, lib, self, inputs, allowed-unfree-packages, ... }:

let

  my-python = pkgs.python312.withPackages (ps: with ps; [
      numpy
      matplotlib
      pandas
      seaborn
      pygments
      jupyter
      graph-tool
      tabulate
      python-dateutil
    ]);
in
{

  imports = [
      inputs.nix-colors.homeManagerModules.default
      ../window_managers/hyprland.nix
      # ../window_managers/hyprlock.nix
      ../window_managers/qtile.nix
      ../programs/alacritty.nix
      ../programs/waybar.nix
      ../programs/wofi.nix
      ../programs/rofi.nix
      ../programs/picom.nix
      ../programs/git.nix
      ../programs/dunst.nix
      ../programs/conky.nix
      ../programs/fish.nix
      ../programs/zsh.nix
      ../programs/bash.nix
      ../programs/zoxide.nix
      ../programs/eza.nix
      ../programs/zathura.nix
      ../programs/autorandr.nix
      ../programs/xscreensaver.nix
      # ../programs/emacs-theme.nix
  ];


  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-soft;
  # colorScheme = inputs.nix-colors.colorSchemes.everforest;
  colorScheme = inputs.nix-colors.colorSchemes.onedark;

  home.username = "virgil";
  home.homeDirectory = "/home/virgil";

  home.stateVersion = "23.05";


  home.packages = with pkgs; [
    (import ../shell_scripts/make-shell.nix {inherit pkgs; })
    (callPackage ../pkgs/custom-i3lock {})
    (callPackage ../pkgs/rofi-sound {})
    base16-schemes
    texlive.combined.scheme-full
    alacritty
    btop
    firefox
    brave
    bitwarden
    mullvad-vpn
    libreoffice
    jetbrains-mono
    vscodium-fhs
    emacs-all-the-icons-fonts
    neofetch
    tree-sitter
    texlab
    signal-desktop
    vlc
    kdePackages.dolphin
    kdePackages.qtsvg
    zathura
    evince
    feh
    # wayland related things
    wofi
    waybar
    swww
    hyprlock
    mpv
    nwg-displays

    # unfree
    # discord

    # linux utilities
    shutter
    gtk3
    webkitgtk
    libusb1
    ripgrep
    coreutils
    fd
    clang
    dmenu
    gnumake
    cmake
    libtool
    libvterm
    alsa-utils
    direnv
    nix-direnv
    fzf
    acpilight
    brightnessctl
    fd
    imagemagick
    scrot
    ffmpegthumbnailer
    mediainfo
    poppler
    i3lock-color                # lock screen
    # for screenshot
    grim
    slurp
    wl-clipboard
    nerdfonts
    #nerd-fonts.ubuntu
    #nerd-fonts.fira-code
    #nerd-fonts.jetbrains-mono
    zip
    unzip
    xclip
    xdotool
    xorg.xprop
    xorg.xwininfo
    glxinfo
    arandr
    flameshot
    biome



    nix-prefetch
    nix-prefetch-github
    nil # nix lsp

    # jetbrains-toolbox

    nodejs
    nodePackages.npm
    nodePackages.yarn
    awscli2
    nodePackages.aws-cdk
    # Arduino
    # arduino

    # Audio
    pavucontrol
    pulseaudio
    # wifi and bluetooth
    blueman
    wirelesstools

    # programming langages
    libclang
    jdk
    nodejs_20
    rustc
    cargo
    rust-analyzer
    ruff-lsp
    pyright
    ruff

    slack-cli
    my-python
  ];


  gtk = {
    theme.name = "Adwaita-dark";
  };

  programs.home-manager.enable = true;

  home.sessionPath = [
   "${my-python}/bin"
   "$HOME/.config/emacs/bin"
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient -t -a ''";
    VISUAL = "emacsclient -c -a emacs";
    TERM = "xterm-256color";
  };

  xsession.enable = true;


}
