{ config, lib, pkgs, ... }:

{
  xdg.configFile = {
    "qtile/config.py".source  = ./config/config.py;
    "qtile/themes.py".source  = ./config/themes.py;
    "qtile/keys.py".source    = ./config/keys.py;
    "qtile/layouts.py".source = ./config/layouts.py;
    "qtile/groups.py".source  = ./config/groups.py;
    "qtile/screens.py".source = ./config/screens.py;
  };
}
