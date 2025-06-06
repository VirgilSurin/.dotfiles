{ config, lib, pkgs, ... }:

{
  programs.onagre = {
    enable = true;
    style = ''
.onagre {
  background: #fdf6e3;
  color: #657b83;
  --icon-theme: "Papirus";
  --font-family: "Monaco";
  --icon-size: 24;
  border-radius: 0;
  border-color: #a9b7c6;
  border-width: 0;
  height: 250px;
  width: 440px;

  .container {
    .rows {
      --height: fill-portion 6;
      .row {

        .icon {
          padding-top: 4px;
        }

        .title {
          font-size: 18px;
        }

        .description {
          font-size: 12px;
        }
      }

      .row-selected {
        --width: 435;
        color: #268bd2;

        .icon {
          padding-top: 4px;
        }

        .title {
          font-size: 20px;
        }

        .description {
          font-size: 12px;
        }
      }
    }

    .search {
      background: #fdf6e3;
      --height: fill-portion 1;
      border-radius: 0;
      border-color: #073642;
      border-width: 3px;
      padding: 4px;
      .input {
        color: #002b36;
        --placeholder-color: #657b83;
        --selection-color: #2aa198;
        font-size: 20px;
        --width: fill-portion 13;
      }
      .plugin-hint {
        font-size: 11px;
        color: #002b36;
        padding: 6px;
        border-color: #859900;
        background: #fdf6e3;
        border-width: 3px;
        --align-x: center;
        --align-y: center;
        --width: fill-portion 2;
        --height: fill;
      }
    }

    .scrollable {
      width: 2px;
      background: #839496;
      .scroller {
        border-radius: 0;
        width: 2px;
        color: #268bd2;
      }
    }
  }
}
'';
  };
}
