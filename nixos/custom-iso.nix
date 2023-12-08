{
  pkgs,
  lib,
  config,
  modulesPath,
  ...
}: let
  # TODO: change git settings to new repo (gitlab)
  git_passwd = "gPO4IUepo7D3z80BjIiI";
  git_base_url = "https://api.bitbucket.org/2.0/repositories";
  git_repo = "sabio-it/sw-services";
  git_branch = "main";

  # -----

  # This is the installer script, which will be written in nix/store/… on the installer ISO

  custom-installer = pkgs.writeScriptBin "custom-installer" ''
    set -euo pipefail

    export DISK=/dev/vda
    export EXT_PART=1
    export EFI_PART=2

    RED='\033[1;31m'
    NORMAL='\033[0;39m'

    echo -e "This script will bootstrap a new NixOS system from a given configuration. It will do the following:"
    echo -e ""
    echo -e "   * querying the target disk (will be completely wiped)"
    echo -e "   * creating 2 file systems (EFI and EXT4)"
    echo -e "   * copying the base configuration from git repository $RED ${git_repo} $NORMAL"
    echo -e "   * querying the hostname and domain and changing it accordingly in the configuration"
    echo -e "   * installing new system and auto-reboot"
    echo -e ""
    echo -e "After rebooting the system is ready to be set up via Colmena. The base config has avahi enabled,"
    echo -e "so the machine is reachable via <hostname>.local"
    echo -e ""
    echo -e "Are you OK with this? Press ENTER to going further or CTRL+C to abort."
    read -r _

    lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,MOUNTPOINTS,LABEL
    echo -e ""
    echo -en "On which drive do you want to install nixos? [$DISK] "
    read -r _DISK
    if [ -n "$_DISK" ]; then
      DISK=$_DISK
    fi


    # create partitions
    sgdisk --zap-all "$DISK"
    sgdisk --new $EFI_PART:1M:+512M --typecode=$EFI_PART:EF00 "$DISK"
    sgdisk --new $EXT_PART:0:0      --typecode=$EXT_PART:BF01 "$DISK"

    # create file systems
    mkfs.ext4 -L nixos "$DISK$EXT_PART"
    mkfs.fat -F 32 -n boot "$DISK$EFI_PART"

    # mount filesystems
    mount "$DISK$EXT_PART" /mnt
    mkdir /mnt/boot
    mount "$DISK$EFI_PART" /mnt/boot

    nixos-generate-config --root /mnt  # --no-filesystem
    curl --request GET --header 'Authorization: Bearer ${git_passwd}' -L '${git_base_url}/${git_repo}/src/${git_branch}/configs/initial-configuration.nix' -o /mnt/etc/nixos/configuration.nix

    echo -e ""
    echo -en "It is recommended to set the hostname but it can be left at the default. [nixos-base-system] "
    read -r HOSTNAME
    echo -en "It is recommended to set the domain but it can be left at the default. [] "
    read -r DOMAIN

    if [ -n "$HOSTNAME" ]; then
      #       substitudeInPlace? -> pkgs/pkgs/servers/calibre-web/default.nix
      #       substitudeInPlace ./configuration.nix --replace "hostname = calibreweb:main" "calibre-web = calibreweb:main"
      ${pkgs.gnused}/bin/sed -i -e "s/hostName = \"nixos-base-system\";/hostName = \"$HOSTNAME\";/g" /mnt/etc/nixos/configuration.nix
    fi
    if [ -n "$DOMAIN" ]; then
      ${pkgs.gnused}/bin/sed -i -e "s/domain = null;/domain = \"$DOMAIN\";/g" /mnt/etc/nixos/configuration.nix
    fi

    echo -e "We are now ready to install. Press ENTER to going further or CTRL+C to abort."
    read -r _
    nixos-install --no-root-passwd

    echo -e "Automatic reboot in 10 seconds…"
    sleep 10
    reboot
  '';
  # -----
  # This describes how to build the installer ISO itself. When running
  #
  #   nix-build custom-iso.nix
  #
  # you get an image as describerd here, derived from installation-cd-minimal.nix (see import)
in {
  imports = [
    (modulesPath
      + "/installer/cd-dvd/installation-cd-minimal.nix") # modulesPath is "nixpkgs:nixos/modules"
  ];

  # isoImage = {
  #   isoName = lib.mkForce
  #     "${config.isoImage.isoBaseName}-${config.system.nixos.release}-${pkgs.stdenv.hostPlatform.system}.iso";
  #   isoBaseName = lib.mkForce "custom-installer.nixos";
  #   compressImage = false;
  #   #squashfsCompression = "gzip -Xcompression-level 1";
  #   includeSystemBuildDependencies =
  #     false; # set to true, in the case of no/slow Internet on the machine to be installed
  # };

  services.getty.helpLine = ''
    This is a custom installer ISO:

      - based on nixos minimal install cd
      - root and admin users with passwords and ssh keys
      - custum installer script which will partition the disk and install a config from git

    You can start the installation with "sudo custom-installer".
  '';

  # -----

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.utf8";
  console.keyMap = "de";

  networking.hostName = "custom-installer";
  # vmxnet3
  environment.systemPackages = [custom-installer];

  users.users.root = {
    hashedPassword = "$6$Qrs5/UsyfHxyY/Ew$7BPp8eUbby6vGD2Tf59UZPwKQa23Rlr7Du4TGMUgxcKtHgdBL6Za1MdFHBjaZmOFDKk6oUvqDAQJ921zlc656."; # nixos
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWJnYCic/2GwDl3i6XnLEGkNGCYzfgQeKNArc7ArG8dRnVJkHpQiixVqaRd6C1Q1PL6yKfY6JAPf3HAdPB2M+nvh4V275ZVS9D03QbBxoxzdBA34dz6Epb0SSGJt5/BfNWKebxuthqwe3EHJh8t+BM1KYtLvw/rEDIpz5dMfqTyYuL4sXMXkAgYZceQkOm9xqSwD89LzidrmsHHT+rfcusV1k8G3mbVMgKiTPRnoyv/GaC4bQBD0f8ibFP1edZeVrWZ2UcOIN6F1i101dGZeJLi2G8GaijWNq4kR1mK1sZl1Y+yCuZH0VH7+31BKEpwi1w3US0mMasH2iIrTQvXNML admin.leli@lap-leli.pmcs.de"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgHtj1nylquRLIyn3gYen2cKuZZyujw5ipkgPez4jeD mike.brasch@sabio.de"
    ];
  };

  users.users.nixos = {
    hashedPassword = "$6$Qrs5/UsyfHxyY/Ew$7BPp8eUbby6vGD2Tf59UZPwKQa23Rlr7Du4TGMUgxcKtHgdBL6Za1MdFHBjaZmOFDKk6oUvqDAQJ921zlc656."; # nixos
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWJnYCic/2GwDl3i6XnLEGkNGCYzfgQeKNArc7ArG8dRnVJkHpQiixVqaRd6C1Q1PL6yKfY6JAPf3HAdPB2M+nvh4V275ZVS9D03QbBxoxzdBA34dz6Epb0SSGJt5/BfNWKebxuthqwe3EHJh8t+BM1KYtLvw/rEDIpz5dMfqTyYuL4sXMXkAgYZceQkOm9xqSwD89LzidrmsHHT+rfcusV1k8G3mbVMgKiTPRnoyv/GaC4bQBD0f8ibFP1edZeVrWZ2UcOIN6F1i101dGZeJLi2G8GaijWNq4kR1mK1sZl1Y+yCuZH0VH7+31BKEpwi1w3US0mMasH2iIrTQvXNML admin.leli@lap-leli.pmcs.de"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgHtj1nylquRLIyn3gYen2cKuZZyujw5ipkgPez4jeD mike.brasch@sabio.de"
    ];
  };
}
