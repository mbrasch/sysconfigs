# Home Manager
#
# official docs:  https://nix-community.github.io/home-manager/
# options search: https://mipmip.github.io/home-manager-option-search

{ pkgs, config, osConfig, options, system, lib, username, inputs, outputs, specialArgs, ... }: 
let
  homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
  
in {
  imports = [
    # You can split up your configuration and import pieces of it here:
    ../common/zsh.nix
    ../common/shell-tools.nix
    
    # If you want to use modules your own flake exports (from modules/home-manager):
    #outputs.homeManagerModules.example
    
    # Or modules exported from other flakes:
    #inputs.nix-colors.homeManagerModules.default
    #inputs.xhmm.homeManagerModules.console.all
    #inputs.stylix.homeManagerModules.stylix
  ]; 



  ##################################################################################################
  ## misc
      
  xdg = {
    enable = true;
    #configHome = "${config.home.homeDirectory}/.config";
  };
  
  manual = {
    manpages.enable = true;
    json.enable = false;
  };  
  
  news.display = "silent";
  
  
  
  ##################################################################################################
  ## user home configuration
  
  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = "23.05";
    
    enableDebugInfo = false;
    
    sessionPath = [
      "$HOME/Library/Python/3.9/bin"
    ];
    
    sessionVariables = {
      #NIX_PATH = "$HOME/.hm-nixchannels";
    };
    
    file = { 
      #"${config.xdg.configHome}/neofetch/config.conf".text = builtins.readFile ./neofetch.conf;
    };

    activation = {
      # print all changes after activating a new home manager generation
      report-changes = config.lib.dag.entryAnywhere ''
        ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
      '';
    };
    
    ###########################################################################
    # install this packages (they appear only in this users context)
    #
    # - via the 'with pkgs;' we can open a namespace so that we can omit the 'pkgs.' in front of
    #   the package name.
    # - to search for packages you can use https://search.nixos.org/packages or 'nix-search'
    
    packages = with pkgs; [
      #------------------------------------------
      # fonts
      
      # we don't need all nerdfonts, so we overwrite the list of fonts to install 
      (nerdfonts.override { fonts = [ "Noto" "FiraCode" "SourceCodePro" "UbuntuMono" "Meslo" ]; })

      #------------------------------------------
      # nix tools
      
      inputs.nix-search.packages.${pkgs.system}.nix-search # CLI for searching packages on search.nixos.org
      alejandra # nix code formatter
      cachix # command line client for Nix binary cache hosting https://cachix.org
      nil # language server for nix
      nix-diff # explain why two Nix derivations differ
      nix-info # get high level info to help with debugging
      nix-init # generate Nix packages from URLs
      nix-melt # ranger-like flake.lock viewer
      nix-output-monitor # parses output of nix-build to show additional information
      nix-tree # interactively browse a Nix store paths dependencies
      nixos-shell
      nixfmt # nix formatter
      nixpacks # takes a source directory and produces an OCI compliant image that can be deployed anywhere
      #rnix-lsp # language server for nix
      nixd  # language server for nix

      #------------------------------------------
      # shell tools

      dua # modern du
      duf # modern df
      gping # ping with graph
      ripgrep # modern grep
      mtr-gui # tracerout + ping
      #ncdu # du with ncurses interface -> build error unable to create compilation: TargetRequiresPIE
      fastfetch
      #stectonic # modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive
      #tokei # modern wc for code
      tree # list directories in a tree
      wakeonlan
      wimlib # extract, create, and modify WIM files
      coreutils # GNU Core Utilities
      davmail # Microsoft Exchange server as local CALDAV, IMAP and SMTP servers
      #figlet # make large letters out of ordinary text
      helix # post-modern modal text editor
      shell_gpt # ChatGPT in your terminal
      libimobiledevice # A cross-platform protocol library to access iOS devices (and Apple Silicon Macs)
      android-tools
      
      git
      lazygit # simple terminal UI for git commands
      git-absorb # git commit --fixup, but automatic
      thefuck
      
      #------------------------------------------
      # languages
      
      nodejs_21
      nodePackages_latest.dockerfile-language-server-nodejs
      #nodePackages.npm
      
      python3Full
      python311Packages.black
      python311Packages.flake8
      python311Packages.pyls-isort
      python311Packages.python-lsp-black
      python311Packages.python-lsp-server
      
      rustc # rust compiler
      rustfmt # rust code formatter
      clippy
      cargo
      
      shellcheck # shell script analysis tool
      shfmt # shell parser and formatter
      
      terraform
      terraform-ls
      
      go
      gopls # language server
      delve # debugger
      
      jq # command-line JSON processor
      jiq # interactive jq
      yq-go # jq for yaml
      

      #------------------------------------------
      # gui apps
      
      diffuse # diff tool
      meld # diff tool (on macos: start via shell)
      qownnotes
    ];
    
  };
  
  
  
  ##################################################################################################
  ## program configurations
  
  programs = {
    home-manager = {
      enable = true;
      #path = pkgs.lib.mkForce "${config.xdg.configHome}/home-manager";
      path = pkgs.lib.mkForce "/Volumes/Shared/Repositories/Privat/sysconfigs";
    };
    
    git = {
      enable = false;
    };
    
    ssh = {
      enable = false;
      matchBlocks = {
        "john.example.com" = {
          hostname = "example.com";
          user = "john";
        };
        # foo = lib.hm.dag.entryBefore ["john.example.com"] {
        #   hostname = "example.com";
        #   identityFile = "/home/john/.ssh/foo_rsa";
        # };
      };
    };
        
    vscode = {
      enable = false;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        ms-ceintl.vscode-language-pack-de
        kamadorueda.alejandra
        jnoortheen.nix-ide
        hashicorp.terraform
        #brettm12345.nixfmt-vscode
        bierner.markdown-mermaid
      ];
    };
  };
  
  
  
  ##################################################################################################
  ## services
  
  services = {
    
  };



  ##################################################################################################
  ## systemd
  
  launchd = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    
  };


  
  ##################################################################################################
  ## systemd
  
  systemd = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    # Nicely reload system units when changing configs
    user.startServices = "sd-switch";
  };
  
}
