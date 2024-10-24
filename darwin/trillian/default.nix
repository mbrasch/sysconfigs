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
    #../common/yabai.nix
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  #virtualisation.darwin-builder.hostPort = 10000; # default port is 31022

  users.users.${username} = {
    name = username; # config.home-manager.users.mike.home;
    home = /Users/${username};
    isHidden = false;
    shell = pkgs.zsh;
  };
  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  environment.systemPackages = [ pkgs.cowsay ];

  system.activationScripts = {
    applications = {
      enable = true;
      text =
        let
          env = pkgs.buildEnv {
            name = "system-applications";
            paths = config.environment.systemPackages;
            pathsToLink = "/Applications";
          };
        in
        pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
        '';
    };
    # print all changes after activating a new home manager generation
    report-changes = {
      enable = true;
      text = ''
        ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
      '';
    };
  };
}
