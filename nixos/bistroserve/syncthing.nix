{ config, ... }:
{
  services.syncthing = {
    enable = false;
    user = "syncthing";
    group = "syncthing";
    dataDir = /var/lib/syncthing;
    #databaseDir = config.services.syncthing.configDir;
    #configDir = config.services.syncthing.dataDir + "/.config/syncthing";
    guiAddress = "127.0.0.1:8384";
    openDefaultPorts = true;
    key = null;
    cert = null;
    overrideDevices = false;
    overrideFolders = false;

    extraFlags = [ ];

    ################################################################################################
    ## options

    settings.options = {
      urAccepted = -1; # don't submit anonymous usage data
      relaysEnabled = null;
      maxFolderConcurrency = null;
      localAnnouncePort = null;
      localAnnounceEnabled = null;
      limitBandwidthInLan = null;
    };

    ################################################################################################
    ## devices

    settings.devices = {
      mbraschPriv = {
        #name = "mbraschPriv";
        id = "RGRYHVN-UOAZZOR-ZH4XADO-YTM4AKY-XJPFFXB-H5OOI2K-D2FBNQX-UCEMJAL";
        autoAcceptFolders = false;
      };

      mbrasch = {
        #name = "mbrasch";
        id = "64GYC4O-HEAMPBM-J73ZMSS-3BWQYTO-AWDP5RZ-JBCKD5V-JC37CW6-QJ6MEQB";
        autoAcceptFolders = false;
      };

      zaphod = {
        #name = "zaphod";
        id = "VPOVBSH-CNLRK65-6NBFBLL-MDHBSWW-G63PYFP-UBAITXD-R66B5HP-MNAYNAB";
        autoAcceptFolders = false;
      };

      wowbagger = {
        #name = "wowbagger";
        id = "QP2CMAJ-S47IXCG-EXTX3PJ-C7PIOH5-6ELBBL6-AI4JWPS-DNZKJLJ-LO32ZQW";
        autoAcceptFolders = false;
      };
    };

    ################################################################################################
    ## folders

    settings.folders = {
      Keepass = {
        enable = true;
        id = "mpa9i-3qymq";
        label = "Keepass";
        path = "";
        copyOwnershipFromParent = false;
        devices = [ "mbrasch" ];
        versioning = {
          type = "staggered"; # simple | trashcan | staggered | external
          fsPath = config.services.syncthing.dataDir + "/versions";
          #params.cleanoutDays = 3600;
          #params.maxAge = 31536000;
        };
      };
    };

    ################################################################################################
    ## relay

    settings.relay = { };
  };
}
