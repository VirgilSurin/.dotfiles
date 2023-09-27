{ config, lib, pkgs, ... }:

{

  home.username = "virgil";
  home.homeDirectory = "/home/virgil";

  home.stateVersion = "23.05";
  
  home.packages = with pkgs; [
    texlive.combined.scheme-full
    alacritty
    ripgrep
    coreutils
    fd
    clang
    nitrogen
    polybar
    dmenu
    gnumake
    cmake
    libtool
    libvterm
    btop
    emacs29
    librewolf
    gnome.gnome-tweaks
    gnome.gnome-software
    gnome-extension-manager
    bitwarden
    mullvad-vpn
    exa                       # the new ls !
  ];

  programs.home-manager.enable = true;
  
  programs.bash = {
    sessionVariables = {
      EDITOR = "emacsclient -t -a ''";
      VISUAL = "emacsclient -c -a emacs";
      TERM = "xterm-256color";
    };

    shellAliases = {
      hh = "echo hello world";
      vi = "nvim";
      vim = "nvim";

      cfg = "sudo nvim /etc/nixos/configuration.nix";
      nrs = "sudo nixos-rebuild switch";

      # Changing "ls" to "exa"
      ls="exa -al --color=always --group-directories-first"; # my preferred listing
      la="exa -a --color=always --group-directories-first";  # all files and dirs
      ll="exa -l --color=always --group-directories-first";  # long format
      lt="exa -aT --color=always --group-directories-first"; # tree listing

      grep="grep --color=auto";

      rr="curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash";

    };

    bashrcExtra = "
        ex ()
          {
            if [ -f \"$1\" ] ; then
              case $1 in
                *.tar.bz2)   tar xjf $1   ;;
                *.tar.gz)    tar xzf $1   ;;
                *.tar)       tar xf $1    ;;
                *.tbz2)      tar xjf $1   ;;
                *.tgz)       tar xzf $1   ;;
                *.zip)       unzip $1     ;;
                *.tar.xz)    tar xf $1    ;;
                *)           echo \"'$1' cannot be extracted via ex()\" ;;
              esac
            else
              echo \"'$1' is not a valid file\"
            fi
          }
        ";
  };

  programs.git = {
    enable = true;
    userName  = "VirgilSurin";
    userEmail = "virgil.surin@student.umons.ac.be";
  };

}
