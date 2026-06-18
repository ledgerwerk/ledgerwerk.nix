{ pkgs, ... }:
pkgs.mkShellNoCC {
  packages = [
    pkgs.bash
    pkgs.coreutils
    pkgs.curl
    pkgs.gnugrep
    pkgs.gnused
    pkgs.jq
    pkgs.nix-prefetch-scripts
    pkgs.nix-update
    pkgs.mypy
  ];

  shellHook = ''
    export PRJ_ROOT=$PWD
  '';
}
