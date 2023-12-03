#!/usr/bin/env sh
# sudo !

rm -f ~/.config/qtile/config.py
rm -f ~/.config/qtile/themes.py
sudo rm -f //etc/nixos/home-configuration.nix
sudo rm -f //etc/nixos/configuration.nix
sudo rm -f //etc/nixos/sddm-theme.nix

ln -f ./config.py ~/.config/qtile/config.py
ln -f ./themes.py ~/.config/qtile/themes.py
sudo ln -f ./home.nix //etc/nixos/home-configuration.nix
sudo ln -f ./configuration.nix //etc/nixos/configuration.nix
sudo ln -f ./sddm-theme.nix //etc/nixos/sddm-theme.nix
