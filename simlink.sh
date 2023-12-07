#!/usr/bin/env sh

# Emacs themes
rm -f ~/.config/doom/themes/*
ln -f ./emacs-themes/* ~/.config/doom/themes/

# Qtile
rm -f ~/.config/qtile/config.py
rm -f ~/.config/qtile/themes.py
ln -f ./config.py ~/.config/qtile/config.py
ln -f ./themes.py ~/.config/qtile/themes.py

# nix
sudo rm -f //etc/nixos/home-configuration.nix
sudo rm -f //etc/nixos/configuration.nix
sudo rm -f //etc/nixos/sddm-theme.nix
sudo ln -f ./home.nix //etc/nixos/home-configuration.nix
sudo ln -f ./configuration.nix //etc/nixos/configuration.nix
sudo ln -f ./sddm-theme.nix //etc/nixos/sddm-theme.nix
