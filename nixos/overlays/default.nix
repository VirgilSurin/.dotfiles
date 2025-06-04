{ inputs, ... }:

{
  # imports my custom pkgs from the "pkgs" directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  unstable-packages = final: _prev: {
    # accessible through "pkgs.unstable"
    unstable = import inputs.unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  modifications = final: prev: {
    qtile= prev.qtile.overrideAttrs (oldAttrs: rec {
      version = "0.31.0";
      src = prev.fetchFromGitHub {
        owner = "qtile";
        repo = "qtile";
        tag = "v${version}";
        hash = "sha256-EqrvBXigMjevPERTcz3EXSRaZP2xSEsOxjuiJ/5QOz0=";
      };
    });
  };
}
