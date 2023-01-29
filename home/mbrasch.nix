# home-manager configuration for the user "mbrasch"
{ config, pkgs, lib, ... }:

{
  home.stateVersion = "22.11";

  imports = [
    ./programs
    ./services
  ];

  home = {

  };
}
