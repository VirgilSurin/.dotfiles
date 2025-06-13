{ config, lib, pkgs, ... }:

{
programs.onagre = {
  enable = true;
  style = ''
.onagre {
  --exit-unfocused: false;
  height: 275px;
  width: 400px;
  --icon-theme: "Papirus";
  --icon-size: 16px;
  --font-family: "Iosevka Nerd Font Mono";
  background: #${config.colorScheme.palette.base00};
  color: #${config.colorScheme.palette.base05};
  border-color: #${config.colorScheme.palette.base08};
  border-width: 0px;
  border-radius: 0.0%;
  padding: 4px;

  .container {
    padding: 8px;
    .search {
      --spacing: 1;
      background: #${config.colorScheme.palette.base07};
      border-radius: 0.0%;
      color: #${config.colorScheme.palette.base05};
      --height: fill-portion 1;

      .plugin-hint {
        font-size: 12px;
        background: #${config.colorScheme.palette.base02};
        color: #${config.colorScheme.palette.base08};
        border-color: #${config.colorScheme.palette.base08};
        --align-x: center;
        --align-y: center;
        --width: fill-portion 1;
        --height: fill;
      }

      .input {
        font-size: 14px;
        color: #${config.colorScheme.palette.base00};
        --width: fill-portion 11;
      }
    }

    .rows {
      --height: fill-portion 8;
      border-radius: 0.0%;

      .row-selected {
        background: #${config.colorScheme.palette.base0D};
        color: #${config.colorScheme.palette.base00};
        --align-y: center;
        border-radius: 0.0%;
        padding-top: 2px;
        padding-bottom: 2px;
        padding-left: 8px;
        padding-right: 8px;

        .title {
          font-size: 12px;
          color: #${config.colorScheme.palette.base00};
        }

        .description {
          font-size: 8px;
          color: #${config.colorScheme.palette.base01};
        }

        .category-icon {
          --icon-size: 12px;
        }
      }

      .row {
        color: #${config.colorScheme.palette.base05};
        padding-top: 2px;
        padding-bottom: 2px;
        padding-left: 8px;
        padding-right: 8px;

        .title {
          font-size: 12px;
          color: #${config.colorScheme.palette.base05};
        }

        .description {
          font-size: 8px;
          color: #${config.colorScheme.palette.base04};
        }

        .category-icon {
          --icon-size: 12px;
        }
      }
    }

    .scrollable {
      background: #${config.colorScheme.palette.base00}00;
      .scroller {
        color: #${config.colorScheme.palette.base03}00;
      }
    }
  }
}
'';
};
}
