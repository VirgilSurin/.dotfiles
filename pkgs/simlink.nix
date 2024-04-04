{  pkgs }:

pkgs.writeShellScriptBin "simlink" ''
# Emacs config
cd ~/.dotfiles/

rm -f ~/.config/doom/init.el
rm -f ~/.config/doom/packages.el
rm -f ~/.config/doom/config.el
ln -f ./config.el ~/.config/doom/config.el
ln -f ./init.el ~/.config/doom/init.el
ln -f ./packages.el ~/.config/doom/packages.el

# Emacs themes
rm -f ~/.config/doom/themes/*
ln -f ./emacs-themes/* ~/.config/doom/themes/

# Qtile
rm -f ~/.config/qtile/config.py
rm -f ~/.config/qtile/themes.py
ln -f ./config.py ~/.config/qtile/config.py
ln -f ./themes.py ~/.config/qtile/themes.py

# nix
sudo rm -f //etc/nixos/home.nix
sudo rm -f //etc/nixos/configuration.nix
sudo rm -f //etc/nixos/sddm-theme.nix
sudo rm -f //etc/nixos/pkgs/*.nix
sudo ln -f ./nixos/home.nix //etc/nixos/home.nix
sudo ln -f ./nixos/configuration.nix //etc/nixos/configuration.nix
sudo ln -f ./nixos/sddm-theme.nix //etc/nixos/sddm-theme.nix
sudo ln -f ./pkgs/* //etc/nixos/pkgs/
''
