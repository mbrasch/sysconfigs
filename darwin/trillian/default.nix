# nix-darwin configuration for the machine "mbrasch"
{
  self,
  #system,
  pkgs,
  inputs,
  ...
}@args:
{

  # includes sub-configurations
  imports = [ ../common/nix-nixpkgs-conf.nix ];

  ##################################################################################################
  ## minimal required config for nix-darwin

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # The platform the configuration will be used on.
  #nixpkgs.hostPlatform = system;

  # includes overlays to default packages
  nixpkgs.overlays = [
    #(import ./overrides/php81.nix)
    #(import ../pkgs)
  ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;
}
