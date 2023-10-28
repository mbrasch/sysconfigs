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
    };

    ###############################################################################################
    ## programs

    programs = {
      home-manager = {
        enable = true;
      };

      # -------------------------------------------------------------------------------------------

      fzf = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };

      # -------------------------------------------------------------------------------------------

      dircolors = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };

      # -------------------------------------------------------------------------------------------

      direnv = {
        enable = false;
        nix-direnv.enable = false;
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
        
        syntaxHighlighting = {
          enable = true;
          styles = { };
        };
        
        historySubstringSearch = {
          enable = true;
          #searchDownKey = [ ];
          #searchUpKey = [ ];
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
        shellGlobalAliases = {
          UUID = "$(uuidgen | tr -d \\n)";
          G = "| grep";
        };

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
        
        # prezto = {
        #   enable = true;
        #   autosuggestions.color = null;
        #   caseSensitive = true;
        #   color = true;
        #   editor.dotExpansion = true;
        #   editor.promptContext = true;
        #   extraConfig = "";
        #   extraFunctions = [ ];
        #   extraModules = [  ];
        #   historySubstring = {
        #     foundColor = null;
        #     globbingFlags = null;
        #     notFoundColor = null;
        #   };
        #   macOS.dashKeyword = "dash";
        #   pmodules = [
        #     "environment"
        #     "terminal"
        #     "editor"
        #     "history"
        #     "spectrum"
        #     "completion" # offers tab-completion from the zsh-completions project
        #     "directory" # sets directory options
        #     "utility" # defines aliases and functions (highlight matches when pressing <tab>)
        #     "git" # displays git repository information in the terminal
        #     "prompt" # defines a theme for your terminal
        #     "syntax-highlighting" # offers fish-like-highlighting statuslinecolorful executables, underlined folders, …
        #     "history-substring-search" # type in a word and press up and down to cycle through matching commands
        #     "autosuggestions"
        #   ];
        #   prompt = {
        #     pwdLength = "short"; # null | "short" | "long" | "full"
        #     showReturnVal = true;
        #     theme = "powerlevel10k";
        #   };
        #   #ssh.identities = [ ];
        #   tmux.itermIntegration = true;
        # };
      };
    };


  };
}