{ pkgs, config, ... }:
{
  ##################################################################################################
  ## config files

  xdg.configFile = {
    fastfetch = {
      enable = true;
      source = ./dotfiles/fastfetch.jsonc;
      target = "./fastfetch/config.jsonc";
    };

    macchina = {
      enable = false;
      source = ./dotfiles/macchina.toml;
      target = "./macchina/macchina.toml";
    };

    powerlevel10k = {
      enable = true;
      source = ./dotfiles/p10k.zsh;
      target = "./zsh/p10k.zsh";
    };

    iterm2_shell_integration = {
      enable = true;
      source = ./dotfiles/.iterm2_shell_integration.zsh;
      target = "./zsh/.iterm2_shell_integration.zsh";
    };

    iterm2 = {
      enable = true;
      recursive = true;
      source = ./dotfiles/.iterm2;
      target = "./zsh/.iterm2";
    };
  };
}
