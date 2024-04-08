{ pkgs }:

pkgs.writeShellScriptBin "make-shell" ''
echo "{ pkgs ? import <nixpkgs> {} }:

let
  python-packages = ps: with ps; [

  ];
  my-python = pkgs.python311.withPackages python-packages;
in
pkgs.mkShell {
  packages = [
    (my-python)
  ];
}" >> shell.nix

echo "use nix" >> .envrc

direnv allow
''
