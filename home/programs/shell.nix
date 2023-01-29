# home-manager configuration related to the shell environment
{ config, pkgs, lib, ... }:

{
  programs = {
    starship.enable = true;

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}