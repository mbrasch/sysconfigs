{ config, pkgs, lib, ... }:

{
  home.programs.ssh = {
    enable = true;
    controlMaster = "auto";
    #controlPath = "${tmp_directory}/ssh-%u-%r@%h:%p";
    controlPersist = "1800";
    forwardAgent = true;
    serverAliveInterval = 60;
    hashKnownHosts = true;

    #extraConfig = ''
    #  #SCE_GROUP:B0713CB6-A009-4E72-AC09-A9DE823B9F60:::Privat
    #  Host BistroServe
    #  User admin
    #  HostName bistroserve
    #  IdentityFile ~/.ssh/private.id.rsa
    #  #SCEIcon home
    #  #SCEGroup B0713CB6-A009-4E72-AC09-A9DE823B9F60
    #  #SCE_GROUP:D34811CE-4F87-4B7F-AFAE-826B9310D5AF:::Serviceware
    #  Host bc-climgmt3.pmcs.de
    #  User mbrasch
    #  IdentityFile ~/.ssh/serviceware.id.rsa
    #  #SCEIcon suitcase
    #  #SCEGroup D34811CE-4F87-4B7F-AFAE-826B9310D5AF
    #'';
  };

}
