{ inputs, ... }:

{
  unstable-packages = final: _prev: {

    # imports my custom pkgs from the "pkgs" directory
    additions = final: _prev: import ../pkgs final.pkgs;

    # accessble through "pkgs.unstable"
    unstable = import inputs.unstable {
      system = final.system;
      config.allowUnfree = true;
    };

    # for custom modifications to packages (version changes etc)
    modifications = final: prev: {
      qtile = prev.qtile-unwrapped.overrideAttrs (oldAttrs: rec {
        version = "0.31.0";
        src = prev.fetchFromGitHub {
          owner = "qtile";
          repo = "qtile";
          tag = "v${version}";
          hash = "sha256-EqrvBXigMjevPERTcz3EXSRaZP2xSEsOxjuiJ/5QOz0=";
        };
      });
    };
  };
}
