# home-manager configuration related to the shell environment
{ config, pkgs, lib, ... }:

{
  home = {

    ###############################################################################################
    ## sessionVariables

    sessionVariables = {
      EDITOR = "${pkgs.nano}/bin/nano";
      #EMAIL = "${config.programs.git.userEmail}";
      PAGER = "${pkgs.less}/bin/less";
      CLICOLOR = true;
      GPG_TTY = "$TTY";
      #PATH = "$PATH:$HOME/.local/bin:$HOME/.tfenv/bin";
    };

    ###############################################################################################
    ## programs

    programs = {
      starship.enable = true;

      # -------------------------------------------------------------------------------------------

      fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      # -------------------------------------------------------------------------------------------

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      # -------------------------------------------------------------------------------------------

      programs.zsh = {
        enable = true;
        dotDir = ".config/zsh";
        enableCompletion = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        autocd = true;

        history = {
          path = "${config.programs.zsh.dotDir}/zsh_history";
          expireDuplicatesFirst = true; # Expire duplicates first.
          extended = true; # Save timestamp into the history file.
          ignoreDups = true; # Do not enter command lines into the history list if they are duplicates of the previous event.
          ignoreSpace = true; # Do not enter command lines into the history list if the first character is a space.
          share = true; # Share command history between zsh sessions.
          save = 10000; # Number of history lines to save.
          size = 10000; # Number of history lines to keep.
        };

        # Extra commands that should be added to .zshenv.
        envExtra = "";

        # Extra commands that should be added to .zshrc.
        initExtra = ''
          zstyle ':completion:*' list-suffixes
          autoload bashcompinit && bashcompinit
        '';

        # Extra commands that should be added to .zshrc before compinit.
        initExtraBeforeCompInit = "";

        # Extra commands that should be added to .zlogin.
        loginExtra = "";

        # Extra commands that should be added to .zlogout.
        logoutExtra = "";

        # Extra local variables defined at the top of .zshrc.
        localVariables = { testvar = "foobar"; };

        # Environment variables that will be set for zsh session.
        sessionVariables = {
          testvar2 = "home-manager is nice";
          EDITOR = "nano";
        };

        # An attribute set that maps aliases (the top level attribute names in this option) to command strings or directly to build outputs.
        shellAliases = {
          ll = "ls -lG";
          ns = "nix search nixpkgs";   # error: cannot find flake 'flake:pkgs' in the flake registries
        };

        # Similar to opt-programs.zsh.shellAliases, but are substituted anywhere on a line.
        #shellGlobalAliases = {
        #  G = "| grep";
        #};

        plugins = [ ]; # Plugins to source in .zshrc

        oh-my-zsh = {
          enable = true;
          theme = "gnzh";

          # Path to a custom oh-my-zsh package to override config of oh-my-zsh.
          custom = "";

          # Extra settings for plugins.
          extraConfig = "";

          plugins = [
            "adb"
            "git"
            "sudo"
            "ansible"
            "vagrant"
            "vagrant-prompt"
            "terraform"
            "cp"
            "docker"
            "docker-compose"
            "docker-machine"
            "fzf"
            "man"
            "pj"
            "ripgrep"
            "ssh-agent"
            "zsh-interactive-cd"
            "timer"
          ];
        };
      };
    };


  };
}