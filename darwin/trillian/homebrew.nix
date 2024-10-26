{
  pkgs,
  inputs,
  username,
  config,
  ...
}:
{
  # opt out from sending analytics. https://docs.brew.sh/Analytics
  environment.variables.HOMEBREW_NO_ANALYTICS = "1";

  # ------------------------------------------------------------------------------------------------
  # documentation: https://github.com/zhaofengli/nix-homebrew

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    mutableTaps = false; # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
    autoMigrate = true;
    user = username;

    # Optional: Declarative tap management
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
  };

  # ------------------------------------------------------------------------------------------------
  # documentation: https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.enable

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
      upgrade = false;

      #Extra flags to pass to brew bundle [install] during nix-darwin system activation
      extraFlags = [
        #"--verbose"
      ];
    };

    # Extra lines to be added verbatim to the bottom of the generated Brewfile
    extraConfig = ''

    '';

    # Options for configuring the behavior of Homebrew commands when you manually invoke them
    global = {
      autoUpdate = true;
    };

    # List of Homebrew formulae to install
    brews = [
      # `brew install`
      # "imagemagick"

      # # `brew install --with-rmtp`, `brew services restart` on version changes
      # {
      #   name = "denji/nginx/nginx-full";
      #   args = [ "with-rmtp" ];
      #   restart_service = "changed";
      # }
      # 
      # # `brew install`, always `brew services restart`, `brew link`, `brew unlink mysql` (if it is installed)
      # {
      #   name = "mysql@5.6";
      #   restart_service = true;
      #   link = true;
      #   conflicts_with = [ "mysql" ];
      # }
    ];

    # List of Homebrew casks to install
    casks = [
      "iterm2@beta"
      "utm@beta"
      "sf-symbols"
      "font-sf-arabic"
      "font-sf-armenian"
      "font-sf-compact"
      "font-sf-georgian"
      "font-sf-hebrew"
      "font-sf-pro"
      "font-sf-mono"
      "font-sf-mono-for-powerline"
      "font-new-york"
    ];

    # Arguments passed to brew install --cask for all casks listed in homebrew.casks.
    caskArgs = {

    };

    # List of Homebrew formula repositories to tap
    #taps = [
    # {
    #   name = "user/tap-repo";
    #   clone_target = "https://user@bitbucket.org/user/homebrew-tap-repo.git";
    #   force_auto_update = true;
    # }
    #];

    # https://github.com/zhaofengli/nix-homebrew/issues/5
    # https://github.com/zhaofengli/nix-homebrew/pull/42
    # "Figured it out - this is because nix-darwin's homebrew module is trying to untap all taps due to its taps attribute being empty by default."
    taps = if config.nix-homebrew.enable then (builtins.attrNames config.nix-homebrew.taps) else [ ];

    # List of Docker images to install using whalebrew
    whalebrews = [

    ];

    # Applications to install from Mac App Store using mas
    masApps = {

    };
  };
}
