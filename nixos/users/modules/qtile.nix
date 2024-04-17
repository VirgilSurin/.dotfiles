{ inputs, pkgs, lib, ... }:

let
  inherit (lib) mkOptions types;
in
{
  options.layouts.monadTall = mkOptions {
    type = types.listOf (types.submodule {
      options = {
        align = mkOptions {
          type = types.str;
          example = "MonadTall._left";
          default = "0";
        };
        change_ratio = mkOptions {
          type = types.float;
          example = 0.05;
          default = 0.1;
        };
        change_size = mkOptions {
          type = types.int;
          example = 20;
          default = 20;
        };
        max_ratio = mkOptions {
          type = types.float;
          example = 0.5;
          default = 0.75;
        };
        min_ratio = mkOptions {
          type = types.float;
          example = 0.5;
          default = 0.25;
        };
        ratio = mkOptions {
          type = types.float;
          example = 0.25;
          default = 0.5;
        };
        min_secondary_size = mkOptions {
          type = types.int;
          example = 50;
          default = 85;
        };
        new_client_position = mkOptions {
          type = types.str;
          example = "before_current";
          default = "after_current";
        };
        borderWidth = mkOptions {
          type = types.int;
          example = 3;
          default = 2;
        };
        margin = mkOptions {
          type = types.int;
          example = 10;
        };
        borderNormal = mkOptions {
          type = types.str;     # TODO: refactor this for regexp matching
          example = "#0FFFFF";
          default = "#000000";
        };
        borderFocus = mkOptions {
          type = types.str;     # TODO: refactor this for regexp matching
          example = "#FF0FFF";
          default = "#FFFFFF";
        };
        single_client_position = mkOptions {
          type = types.nullOr types.int;
          example = 5;
          default = null;
        };
        single_margin = mkOptions {
          type = types.nullOr types.int;
          example = 5;
          default = null;
        };
      };
    });
    default = [];
  };
}
