{
  self,
  config,
  pkgs,
  inputs,
  username,
  hostname,
  ...
}@args:
{
  imports = [
    ../common/nix-nixpkgs-conf.nix
  ];

  ##################################################################################################
  ## minimal required config for nix-darwin

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  #virtualisation.darwin-builder.hostPort = 10000; # default port is 31022

  users.users.${username} = {
    name = username; # config.home-manager.users.mike.home;
  };

  # The platform the configuration will be used on.
  #nixpkgs.hostPlatform = system;

  # includes overlays to default packages
  nixpkgs.overlays = [
    #(import ./overrides/php81.nix)
    #(import ../pkgs)
  ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  system.activationScripts = {
    # applications.text =
    #   let
    #     env = pkgs.buildEnv {
    #       name = "system-applications";
    #       paths = self.config.environment.systemPackages;
    #       pathsToLink = "/Applications";
    #     };
    #   in
    #   pkgs.lib.mkForce ''
    #     # Set up applications.
    #     echo "setting up /Applications..." >&2
    #     rm -rf /Applications/Nix\ Apps
    #     mkdir -p /Applications/Nix\ Apps
    #     find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
    #     while read src; do
    #       app_name=$(basename "$src")
    #       echo "copying $src" >&2
    #       ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
    #     done
    #   '';

    # print all changes after activating a new home manager generation
    #report-changes.text = ''
    #  ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
    #'';
  };
}
