{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./git
    ./shell-tools.nix
    ./ssh.nix
    ./zsh.nix
    ./dotfiles.nix
  ];
}
