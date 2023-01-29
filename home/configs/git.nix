{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;

    delta.enable = true;

    userEmail = "mike@mbrasch.de";
    userName = "Mike Brasch";

    extraConfig = {
      commit.gpgsign = false;
      push.default = "current";
      fetch.prune = true;
      pull.rebase = true;
      init.defaultBranch = "main";
      gpg.format = "ssh";
      tag.gpgsign = true;

      user.signingKey = "";

      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
    };

    ignores = [
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"

      "._*"

      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"
    ];
  };
}
