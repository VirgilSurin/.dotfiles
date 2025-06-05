{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    autosuggestion.highlight = "fg=#${config.colorScheme.palette.base03}";
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "intheloop";
    };

    shellAliases = {
      vi="nvim";
      vim="nvim";
      rebuild="doas nixos-rebuild switch --flake ~/.dotfiles/nixos/#virgil";
      # ls="eza -al --color=always --group-directories-first --icons"; # my preferred listing
      # la="eza -a --color=always --group-directories-first --icons";  # all files and dirs
      # ll="eza -l --color=always --group-directories-first --icons";  # long format
      # lt="eza -aT --color=always --group-directories-first --icons"; # tree listing
      grep="grep --color=auto";

    };

    initContent =  ''
vterm_printf() {
    if [ -n "$TMUX" ] \
        && { [ "$\{TERM%%-*}" = "tmux" ] \
            || [ "$\{TERM%%-*}" = "screen" ]; }; then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "$\{TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}
colorscript random
'';
  };
}
