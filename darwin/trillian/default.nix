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
    ./homebrew.nix
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  documentation = {
    enable = true;
    doc.enable = true;
    info.enable = true;
    man.enable = true;
  };

  #darwinConfig = "$HOME/.nixpkgs/darwin-configuration.nix";

  users.users.${username} = {
    name = username; # config.home-manager.users.mike.home;
    home = /Users/${username};
    isHidden = false;
    shell = pkgs.zsh;
  };

  # ------------------------------------------------------------------------------------------------

  # The set of packages that appear in /run/current-system/sw. These packages are automatically available to all users, and are automatically updated every time you rebuild the system configuration. (The latter is the main difference with installing them in the default profile, /nix/var/nix/profiles/default
  environment.systemPackages = [
    pkgs.cowsay
  ];

  environment.etc = { };

  # List of additional package outputs to be symlinked into /run/current-system/sw
  environment.extraOutputsToInstall = [ ];

  # List of directories to be symlinked in /run/current-system/sw
  environment.pathsToLink = [ ];

  # Set of files that have to be linked in /Library/LaunchAgents
  environment.launchAgents = { };

  # Set of files that have to be linked in /Library/LaunchDaemons
  environment.launchDaemons = { };

  # Set of files that have to be linked in ~/Library/LaunchAgents
  environment.userLaunchAgents = { };

  # An attribute set that maps aliases (the top level attribute names in this option) to command strings or directly to build outputs. The alises are added to all users’ shells
  environment.shellAliases = { };

  # A list of permissible login shells for user accounts. No need to mention /bin/sh and other shells that are available by default on macOS
  environment.shells = [ pkgs.zsh ];

  # The set of paths that are added to PATH
  environment.systemPath = [ ];

  # ------------------------------------------------------------------------------------------------

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # ------------------------------------------------------------------------------------------------

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

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
