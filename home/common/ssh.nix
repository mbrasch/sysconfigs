{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.ssh = {
    enable = true;
    includes = [
      #"~/.ssh/config.private"
    ];
    AddKeysToAgent = "confirm";

    matchBlocks = {
      # "*" = {
      #   hostname = "*";
      #   identityFile = "IdentityAgent ~/Library/Group\ Containers/group.strongbox.mac.mcguill/agent.sock";
      #   IdentitiesOnly = true;
      # };
    };

    extraConfig = ''
      Host *
      IdentityAgent ~/Library/Group\ Containers/group.strongbox.mac.mcguill/agent.sock
      IdentitiesOnly yes
    '';
  };

  # this option is only available for linux
  services.ssh-agent = lib.mkIf pkgs.stdenv.hostPlatform.isLinux { enable = true; };

}
