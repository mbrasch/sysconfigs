# home-manager configuration for the user "mbrasch"
{ config, pkgs, lib, ... }:

{
  home.stateVersion = "23.05";

  imports = [
    ../common/shell.nix
    #../common/ssh.nix    
  ];

  ######################################################################################################################
  ## config files
  
  xdg.configFile = {
    fastfetch = {
      enable = true;
      source = "./configs/fastfetch.jsonc";
      target = "./fastfetch/config.jsonc";
    };
    
    powerlevel10k = {
      enable = true;
      source = "./configs/p10k.zsh";
      target = "./zsh/p10k.zsh";
    };
  };
}
