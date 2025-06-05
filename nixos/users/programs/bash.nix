{ config, lib, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {

      # man="emacsclient -c -a 'emacs' --eval '(man \'$1\')'";

      hh="echo hello world";
      vi="nvim";
      vim="nvim";

      # python="python3.11";
      # python3="python3.11";

      cfg="doas nvim /etc/nixos/configuration.nix";
      nrs="doas nixos-rebuild switch --flake ~/.dotfiles/nixos/#virgil";
      hms="home-manager switch";

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

vterm_printf() {
    if [ -n \"\$TMUX\" ] && ([ \"\${TERM%%-*}\" = \"tmux\" ] || [ \"\${TERM%%-*}\" = \"screen\" ]); then
        # Tell tmux to pass the escape sequences through
        printf \"\\ePtmux;\\e\\e]%s\\007\\e\\\\\" \"\$1\"
    elif [ \"\${TERM%%-*}\" = \"screen\" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf \"\\eP\\e]%s\\007\\e\\\\\" \"\$1\"
    else
        printf \"\\e]%s\\e\\\\\" \"\$1\"
    fi
}
        ";

  };
}
