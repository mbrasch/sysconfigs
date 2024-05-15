{ pkgs, config, ... }:
{

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    autosuggestion.highlight = null; # example: "fg=#ff00ff,bg=cyan,bold,underline"
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = true;
    dotDir = ".config/zsh";

    history = {
      path = "${config.xdg.configHome}/zsh/zsh_history";
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = false;
      ignorePatterns = [ ];
      ignoreSpace = true;
      save = 10000;
      share = true;
      size = 10000;
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

    localVariables = { };
    sessionVariables = { };

    # An attribute set that maps aliases (the top level attribute names inthis option) to command
    #   strings or directly to build outputs.
    shellAliases = {
      #fuck = "thefuck";
    };

    # Similar to programs.zsh.shellAliases, but are substituted anywhere on a line.
    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";
      G = "| grep";
    };

    #plugins = { ... };

    # Commands that should be added to top of .zshrc.
    initExtraFirst = ''
      #${pkgs.fastfetch}/bin/fastfetch
      source ${config.xdg.configHome}/zsh/p10k.zsh
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
      eval $(thefuck --alias)
    '';

    # Extra commands that should be added to .zshrc.
    #initExtra = builtins.readFile ./p10k.zsh;
    initExtra = ''
      # zsh support for the nix run and nix-shell environments of the Nix package manager.
      #${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
      (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"')
    '';

    prezto = {
      enable = true;
      autosuggestions.color = null;
      caseSensitive = true;
      color = true;
      editor.dotExpansion = true;
      editor.promptContext = true;
      extraConfig = "";
      extraFunctions = [ ];
      extraModules = [ ];
      historySubstring = {
        foundColor = null;
        globbingFlags = null;
        notFoundColor = null;
      };
      macOS.dashKeyword = "dash";
      pmodules = [
        "environment"
        "terminal"
        "editor"
        "history"
        "spectrum"
        "completion" # offers tab-completion from the zsh-completions project
        "directory" # sets directory options
        "utility" # defines aliases and functions (highlight matches when pressing <tab>)
        "git" # displays git repository information in the terminal
        "prompt" # defines a theme for your terminal
        "syntax-highlighting" # offers fish-like-highlighting statuslinecolorful executables, underlined folders, …
        "history-substring-search" # type in a word and press up and down to cycle through matching commands
        "autosuggestions"
      ];
      prompt = {
        pwdLength = "short"; # null | "short" | "long" | "full"
        showReturnVal = true;
        theme = "powerlevel10k";
      };
      #ssh.identities = [ ];
      tmux.itermIntegration = true;
    };
  };

  ##################################################################################################
  ## config files

  xdg.configFile = {
    fastfetch = {
      enable = true;
      source = ./configs/fastfetch.jsonc;
      target = "./fastfetch/config.jsonc";
    };

    powerlevel10k = {
      enable = true;
      source = ./configs/p10k.zsh;
      target = "./zsh/p10k.zsh";
    };
  };
}
