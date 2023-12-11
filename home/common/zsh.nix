{ pkgs, config, ... }: {
  
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
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
    shellAliases = { };
    
    # Similar to programs.zsh.shellAliases, but are substituted anywhere on a line.
    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";
      G = "| grep";
    };
    
    #plugins = { ... };

    initExtraFirst = ''
      #${pkgs.fastfetch}/bin/fastfetch
      source ${config.xdg.configHome}/zsh/p10k.zsh
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
    
    #initExtra = builtins.readFile ./p10k.zsh;
    initExtra = ''
      sce-run() {
        nix develop --impure git+ssh://azdops.serviceware.net/sw/Platform/Operations/_git/swops-sce-env#$1
      }
      
      sce-show() {
        nix flake show git+ssh://azdops.serviceware.net/sw/Platform/Operations/_git/swops-sce-env
      }
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
      extraModules = [  ];
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
  
  ######################################################################################################################
  ## config files
  
  xdg.configFile = {
    fastfetch = {
      enable = true;
      target = "./fastfetch/config.jsonc";
      source = ./configs/fastfetch.jsonc;
    };
    
    powerlevel10k = {
      enable = true;
      target = "./zsh/p10k.zsh";
      source = ./configs/p10k.zsh;
    };
  };

}
