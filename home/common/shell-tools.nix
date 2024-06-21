{ pkgs, config, ... }:
{
  home = {
    shellAliases = {
      hms = "home-manager switch --flake ${config.programs.home-manager.path}";
      hmu = "nix flake update ${config.programs.home-manager.path} && hms";
      hmgc = "home-manager generations expire-generations '-1 days'";
      hmpush = "cd ${config.programs.home-manager.path} && git commit -a -m '.' && git push";
    };

    sessionVariables = { };
  };

  ##################################################################################################
  ##
  ## By default Home Manager will install the package provided by your chosen inputs.nixpkgs (in
  ## your flake.nix) but occasionally you might end up needing to change this package. This can
  ## typically be done in two ways.
  ##
  ##  - If the module provides a package option, such as programs.beets.package, then this is the
  ##    recommended way to perform the override. For example:
  ##
  ##      programs.XXX.package = pkgs.XXX.override { XXX = true; };
  ##
  ##    To see the options you can override, you need to look into the nixpkgs package definition.
  ##    hint: to find a package in the nixpkgs hierarchy easier, search for it in the file
  ##
  ##      https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/all-packages.nix
  ##
  ##    so you will see, that XXX is defined in
  ##
  ##      https://github.com/NixOS/nixpkgs/blob/master/pkgs/XXX
  ##
  ##    at the top, in the function header, are the parameters that can be overwritten.
  ##
  ##  - ööööööhmmmm… I have forgotten the othe way. :)

  programs = {
    atuin = {
      enable = false;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    bat = {
      # modern variant of cat
      enable = true;
      config = { };
      themes = { };
      extraPackages = with pkgs.bat-extras; [
        batwatch
        prettybat
      ];
    };

    broot = {
      # interactively traverse throug your filesystem tree
      enable = false;
      settings = {
        modal = true;
        skin = { };
        verbs = [ ];
      };
    };

    bottom = {
      # system monitor like top. command: btm
      enable = true;
      settings = {
        colors = {
          high_battery_color = "green";
          medium_battery_color = "yellow";
          low_battery_color = "red";
        };
        disk_filter = {
          is_list_ignored = true;
          list = [ "/dev/loop" ];
          regex = true;
          case_sensitive = false;
          whole_word = false;
        };
        flags = {
          dot_marker = false;
          enable_gpu_memory = true;
          group_processes = true;
          hide_table_gap = true;
          mem_as_value = true;
          tree = true;
        };
      };
    };

    lsd = {
      # modern ls
      enable = true;
      enableAliases = true;
    };

    fzf = {
      # fuzzy finder
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    nix-index = {
      # commands: nix-index, nix-locate
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      config = { };
    };

    info.enable = true;
    tealdeer.enable = true;

    gh = {
      enable = false;
      extensions = with pkgs; [
        gh-markdown-preview
        gh-dash
        gh-actions-cache
        gh-eco
      ];
      settings = {
        editor = "nano";
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };
  };
}
