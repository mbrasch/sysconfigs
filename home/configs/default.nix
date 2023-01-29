{ config, pkgs, lib, ... }:

{
  imports = [
    #./git
    ./shell
    ./yabai
  ];
}