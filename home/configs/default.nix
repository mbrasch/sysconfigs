{ config, pkgs, lib, ... }:

{
  imports = [
    ./git
    ./shell.nix
    ./ssh.nix
    ./yabai.nix
  ];
}
