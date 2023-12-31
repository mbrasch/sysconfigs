{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
  ];

  system.stateVersion = "22.11";

  # Bootloader
  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
  };

  nix = {
    settings = {
      allowed-users = ["root" "mike" "builder"];
      #extra-platforms = [ "aarch64-linux" ];
      auto-optimise-store = true;
    };

    distributedBuilds = false; # allow build on other machines in buildMachines?
    buildMachines = [
      #{
      #  hostName = "localhost";
      #  systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
      #  supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
      #  maxJobs = 8;
      #c}
    ];

    sshServe = {
      enable = false;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgHtj1nylquRLIyn3gYen2cKuZZyujw5ipkgPez4jeD mike.brasch@sabio.de"
      ];
      protocol = "ssh"; # ssh | ssh-ng
      write = "false"; # when true -> add "nix-ssh" to nix.settings.trusted-users
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
      keep-outputs = false
      keep-derivations = false

      connect-timeout = 5
      log-lines = 25
      min-free = 128000000
      max-free = 1000000000

      fallback = true
      warn-dirty = true
      auto-optimise-store = true
    '';

    gc = {
      automatic = true;
      dates = "dayly"; # The format is described in systemd.time
      persistent = true;
      randomizedDelaySec = "0"; # The format is described in systemd.time
      options = "--delete-older-than '7d'";
    };

    #optimise = {
    #  automatic = true;
    #  dates = ["03:45"]; # The format is described in systemd.time
    #};
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };

  # --------------------------------------------------------------------------------------------------------------------

  networking = {
    hostName = "nixos"; # Define your hostname.

    networkmanager.enable = true;
    resolvconf.enable = true;

    # Use networkd instead of the pile of shell scripts
    #useNetworkd = lib.mkDefault true;
    #useDHCP = lib.mkDefault false;

    firewall.allowPing = true;
  };

  # The notion of "online" is a broken concept
  # https://github.com/systemd/systemd/blob/e1b45a756f71deac8c1aa9a008bd0dab47f64777/NEWS#L13
  #systemd.services.NetworkManager-wait-online.enable = false;
  #systemd.network.wait-online.enable = false;

  # FIXME: Maybe upstream?
  # Do not take down the network for too long when upgrading,
  # This also prevents failures of services that are restarted instead of stopped.
  # It will use `systemctl restart` rather than stopping it with `systemctl stop`
  # followed by a delayed `systemctl start`.
  #systemd.services.systemd-networkd.stopIfChanged = false;
  # Services that are only restarted might be not able to resolve when resolved is stopped before
  #systemd.services.systemd-resolved.stopIfChanged = false;

  services.resolved = {
    enable = false;
    dnssec = "allow-downgrade";
    llmnr = "true";
    domains = ["local"];
    extraConfig = ''
      DNSOverTLS=opportunistic
      MulticastDNS=yes
    '';
    fallbackDns = ["9.9.9.9" "2620:fe::fe"]; # quad9
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      domain = true;
      addresses = true;
      userServices = true;
      hinfo = true;
    };
  };

  services.openssh = {
    enable = true;
    settings = {PermitRootLogin = "prohibit-password";};
  };

  services.openvpn.servers = {
    vpn-hh = {
      autoStart = false;
      updateResolvConf = true;
      up = "echo nameserver $nameserver | ${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev";
      down = "${pkgs.openresolv}/sbin/resolvconf -d $dev";
      config = "config /etc/ovpn/config.ovpn";
    };
  };

  # --------------------------------------------------------------------------------------------------------------------

  time.timeZone = "Europe/Berlin";

  console.keyMap = "de";

  i18n.extraLocaleSettings = {
    defaultLocale = "de_DE.UTF-8";
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver = {
    enable = true;
    layout = "de";
    xkbVariant = "";
    libinput.enable = true;

    displayManager.lightdm.enable = true; # pantheon

    desktopManager = {
      pantheon = {
        enable = true;
        extraWingpanelIndicators = [];
        extraSwitchboardPlugs = [];
      };

      plasma5 = {enable = false;};
    };
  };

  # --------------------------------------------------------------------------------------------------------------------

  services.spice-webdavd.enable = true;
  services.spice-vdagentd.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
  };
  
  # --------------------------------------------------------------------------------------------------------------------
  
  services.paperless = {
    enable = true;
    user = "paperless";
    adress = "localhost";
    port = "28981";
    passwordFile = "/run/keys/paperless-password";

    dataDir = "/var/lib/paperless";
    mediaDir = "${config.services.paperless.dataDir}/media";
    consumptionDir = "${config.services.paperless.dataDir}/consume";
    consumptionDirIsPublic = false;
    
    # configuration options: https://docs.paperless-ngx.com/configuration/
    extraConfig = {
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_CONSUMER_IGNORE_PATTERN = builtins.toJSON [ ".DS_STORE/*" "desktop.ini" ];
      
      PAPERLESS_OCR_USER_ARGS = builtins.toJSON {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
  };

  # --------------------------------------------------------------------------------------------------------------------

  environment = {
    systemPackages = with pkgs; [firefox git curl bat fzf btop dig nmap];
    variables = {
      QT_QPA_PLATFORM_PLUGIN_PATH = "${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.version}/plugins";
    };
  };

  # --------------------------------------------------------------------------------------------------------------------

  users.users = {
    root = {
      hashedPassword = "$6$R9iwd0gKNHlnLKfD$7rtv9iHdjhKATmnMqOdcMvfXuPk.PNbraeIq9alURhgAsW6KDEZg50b8k3jGn/A5QM7qKOFM330.8Q7EEyofX0";
      shell = pkgs.zsh;
      openssh = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgHtj1nylquRLIyn3gYen2cKuZZyujw5ipkgPez4jeD mike.brasch@sabio.de"
        ];
      };
    };

    mike = {
      isNormalUser = true;
      description = "Mike";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgHtj1nylquRLIyn3gYen2cKuZZyujw5ipkgPez4jeD mike.brasch@sabio.de"
      ];
    };

    builder = {
      description = "user for remote building";
      isSystemUser = true;
      createHome = false;
      group = "builder";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgHtj1nylquRLIyn3gYen2cKuZZyujw5ipkgPez4jeD mike.brasch@sabio.de"
      ];
    };
  };

  # --------------------------------------------------------------------------------------------------------------------

  programs = {
    mtr.enable =
      false; # Some programs need SUID wrappers, can be configured further or are started in user sessions.

    command-not-found.enable = false;

    gnupg.agent = {
      enable = false;
      enableSSHSupport = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableBashCompletion = true;
      zsh-autoenv.enable = false;

      autosuggestions = {
        enable = true;
        async = true;
        strategy = ["completion" "history"];
      };

      syntaxHighlighting = {
        enable = true;
        highlighters = ["main"]; # main, brackets, pattern, cursor, regexp, root, line
      };

      shellAliases = {
        nru = "sudo nix flake update /etc/nixos";
        nre = "sudo nano /etc/nixos/configuration.nix";
        nrs = "sudo nixos-rebuild switch";

        vpn-up = "systemctl start openvpn-vpn-hh.service";
        vpn-down = "systemctl stop openvpn-vpn-hh.service";
        vpn-status = "systemctl status openvpn-vpn-hh.service";
      };

      interactiveShellInit = ''
        ${pkgs.neofetch}/bin/neofetch --package_managers on --os_arch on --disk_display infobar --disk_show "/" --disk_subtitle "dir"
        echo "Defined aliases:"
        echo "------------------------------------------------------"
        echo "	nru        = sudo nix flake update /etc/nixos"
        echo "	nre        = sudo nano /etc/nixos/configuration.nix"
        echo "	nrs        = sudo nixos-rebuild switch"
        echo "	vpn-up     = systemctl start openvpn-vpn-hh.service"
        echo "	vpn-down   = systemctl stop openvpn-vpn-hh.service"
        echo "	vpn-status = systemctl status openvpn-vpn-hh.service"
      '';
    };
  };
}
