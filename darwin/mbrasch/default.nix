# nix-darwin configuration for the machine "mbrasch"
{ pkgs, ... }:
{
  # includes sub-configurations
  imports = [

  ];

  # includes overlays to default packages
  nixpkgs.overlays = [
    #(import ./overrides/php81.nix)
    #(import ../pkgs)
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  nix.extraOptions = ''
      experimental-features = nix-command flakes
  '';

  environment.shells = [ pkgs.zsh ];

}