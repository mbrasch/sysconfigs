{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
  ./nix-conf.nix
  ./nixpkgs-conf.nix
  ];
}
