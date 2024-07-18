# homeConfiguration
#
# official docs:  https://nix-community.github.io/home-manager/
# options search: https://mipmip.github.io/home-manager-option-search

{
  pkgs,
  config,
  osConfig,
  options,
  #system,
  lib,
  username,
  inputs,
  outputs,
  ...
}:
let
  system = pkgs.system;
  homeDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  imports = [
    # You can split up your configuration and import pieces of it here:
    ../common/zsh.nix
    ../common/shell-tools.nix
    #../common/nix-nixpkgs-conf.nix
    ../common/dotfiles.nix
    #../common/ssh.nix

    # If you want to use modules your own flake exports (from modules/home-manager):
    #outputs.homeManagerModules.example

    # Or modules exported from other flakes:
    #inputs.nix-colors.homeManagerModules.default
    #inputs.xhmm.homeManagerModules.console.all
    #inputs.stylix.homeManagerModules.stylix
  ];

  #nixpkgs = {
  #  overlays = [ inputs.brew-nix.overlay.${builtins.currentSystem} ];
  #};

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
  ## nixpkgs

  # nixpkgs = {
  #   overlays = [ inputs.brew-nix.overlay.${pkgs.builtins.currentSystem} ];
  # };

  ##################################################################################################
  ## user home configuration

  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = "23.05";

    enableDebugInfo = false;

    sessionPath = [ ];

    sessionVariables = {
      #NIX_PATH = "$HOME/.hm-nixchannels";
      EDITOR = "nano";
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

    ################################################################################################
    # install this packages (they appear only in this users context)
    #
    # - via the 'with pkgs;' we can open a namespace so that we can omit the 'pkgs.' in front of
    #   the package name.
    # - to search for packages you can use https://search.nixos.org/packages or 'nix-search'

    packages = with pkgs; [
      nixVersions.latest

      #------------------------------------------
      # fonts

      # we don't need all nerdfonts, so we overwrite the list of fonts to install 
      (nerdfonts.override {
        fonts = [
          "Noto"
          "FiraCode"
          "SourceCodePro"
          "UbuntuMono"
          "Meslo"
        ];
      })

      #------------------------------------------
      # nix tools

      inputs.nix-search.packages.${system}.nix-search # CLI for searching packages on search.nixos.org
      #inputs.grep-nixos-cache.defaultPackage.${system}
      #inputs.nix-fast-build.packages.${pkgs.system}.nix-fast-build

      cachix # command line client for Nix binary cache hosting https://cachix.org
      nix-diff # explain why two Nix derivations differ
      nix-info # get high level info to help with debugging
      nix-init # generate Nix packages from URLs
      nix-melt # ranger-like flake.lock viewer
      nix-output-monitor # parses output of nix-build to show additional information
      nix-tree # interactively browse a Nix store paths dependencies
      nix-inspect # interactive TUI for inspecting nix configs and other expressions
      nixos-shell
      nixfmt-rfc-style # nix formatter
      nixpacks # takes a source directory and produces an OCI compliant image that can be deployed anywhere
      nixd # language server for nix -> error: Package ‘nix-2.16.2’ in /nix/store/ihkdxl68qh2kcsr33z2jhvfdrpcf7xrg-source/pkgs/tools/package-management/nix/default.nix:229 is marked as insecure, refusing to evaluate.
      devenv

      #------------------------------------------
      # shell tools

      dua # modern du
      duf # modern df
      gping # ping with graph
      ripgrep # modern grep
      mtr-gui # tracerout + ping
      #ncdu # du with ncurses interface -> build error unable to create compilation: TargetRequiresPIE
      fastfetch # like neofetch, but much faster because written in C
      #macchina # like neofetch, but much faster because written in Rust
      #tectonic # modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive
      tokei # modern wc for code
      tree # list directories in a tree
      wakeonlan
      # wimlib # extract, create, and modify WIM files : build error
      coreutils # GNU Core Utilities
      davmail # Microsoft Exchange server as local CALDAV, IMAP and SMTP servers
      #figlet # make large letters out of ordinary text
      helix # post-modern modal text editor
      shell-gpt # ChatGPT in your terminal
      libimobiledevice # A cross-platform protocol library to access iOS devices (and Apple Silicon Macs)
      android-tools
      asitop # Perf monitoring CLI tool for Apple Silicon

      git
      lazygit # simple terminal UI for git commands
      git-absorb # git commit --fixup, but automatic
      thefuck

      inxi
      #(inxi.override { withRecommends = true; }) # A full featured CLI system information tool

      ollama
      aichat
      tailscale

      #------------------------------------------
      # https://libimobiledevice.org

      #idevicerestore # Restore/upgrade firmware of iOS and macOS/AS devices
      #ideviceinstaller # List/modify installed apps of iOS devices

      #------------------------------------------
      # docker

      docker
      docker-compose
      dockerfile-language-server-nodejs
      docker-compose-language-service

      #------------------------------------------
      # languages

      nodejs
      mermaid-cli

      (python3.withPackages (p: [
        p.black
        p.flake8
        p.pyls-isort
        p.python-lsp-black
        p.python-lsp-server
      ]))
      #python3Full
      #python3Packages.black
      #python3Packages.flake8
      #python3Packages.pyls-isort
      #python311Packages.python-lsp-black
      #python311Packages.python-lsp-server

      clang-tools_18

      rustc # rust compiler
      rustfmt # rust code formatter
      clippy
      cargo

      shellcheck # shell script analysis tool
      shfmt # shell parser and formatter

      go
      gopls # language server
      delve # debugger

      jq # command-line JSON processor
      jiq # interactive jq
      yq-go # jq for yaml

      vimPlugins.copilot-vim # for "Copilot for Xcode"

      #------------------------------------------
      # gui apps

      #diffuse # diff tool
      #meld # diff tool (on macos: start via shell)
      #qownnotes # Plain-text file notepad and todo-list manager with markdown support and Nextcloud/ownCloud integration

      #------------------------------------------
      # brew casks (via brew-nix)

      #brewCasks.marta

      #------------------------------------------
      # my own packages

      #( pkgs.callPackage ./pkgs/foobar.nix )
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
