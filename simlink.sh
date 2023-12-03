#!/usr/bin/env sh
# sudo !

ln -sf config.py ~/.config/qtile/config.py
ln -sf theme.py ~/.config/qtile/theme.py

sudo ln -f home.nix //etc/nixos/home-configuration.nix
sudo ln -f configuration.nix //etc/nixos/configuration.nix
sudo ln -f sddm-theme.nix //etc/nixos/sddm-theme.nix
