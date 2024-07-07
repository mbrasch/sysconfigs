{
  ## for more infos about flakes, see:
  ##    https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake

  description = "Various Nix configurations for Darwin and NixOS";

  ##################################################################################################
  ## nixConfig
  ##
  ## here you can configure nix specific to this project. you may (and probably will) asked for
  ## your permissions for security relevant settings.
  ##
  ## For the extra-substituters, you need add your username to the trusted list
  ##   in /etc/nix/nix.conf. Edit this file direct
  ##
  ##      trusted-users = mike
  ##
  ##   or via nix configuration)
  ##
  ##      nix.settings.trusted-users = [ "mike" ];

  nixConfig = {
    #bash-prompt = "\[sysconfigs\]$ ";
    #experimental-features = [  ];

    #buildMachines = [
    #  "ssh://root@nixos.local aarch64-linux,x86_64-linux"
    #];
    
    builders-use-substitutes = true;
    # append "?priority=n" to the end of the URL to set the priority of the substituter (highest priority is 0)
    extra-trusted-substituters = [
      "https://devenv.cachix.org?priority=1"
      "https://nix-community.cachix.org?priority=2"
    ];
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  ##################################################################################################
  ## inputs
  ##
  ## introspect   -> nix flake metadata
  ## update       -> nix flake update
  ##
  ## use "git+file:///to/project/path" for local references (only during development of this flake)

  inputs = {
    # Nix Packages collection & NixOS 
    # documentation:  https://nixos.org/manual/nixpkgs/stable/
    #                 https://nixos.org/manual/nix/stable/
    # package search: https://search.nixos.org/packages
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    #nixpkgs.url = "github:mbrasch/nixpkgs";

    # Nix Packages collection & NixOS 
    # documentation:  https://nixos.org/manual/nixos/stable/
    # options search: https://search.nixos.org/options
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # nix modules for darwin (the equivalent of NixOS modules for macOS)
    # documentation: https://daiderd.com/nix-darwin
    # options:       https://daiderd.com/nix-darwin/manual
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Homebrew installation manager for nix-darwin
    # documentation: https://github.com/zhaofengli/nix-homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;
    homebrew-bundle.url = "github:homebrew/homebrew-bundle";
    homebrew-bundle.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;

    # Homebrew casks, nixified
    # documentation: https://github.com/jacekszymanski/nixcasks/
    #nixcasks.url = "github:jacekszymanski/nixcasks";
    #nixcasks.inputs.nixpkgs.follows = "nixpkgs";

    # Experimental nix expression to package all MacOS casks from homebrew automatically
    #brew-nix.url = "github:BatteredBunny/brew-nix";
    #brew-nix.inputs.nixpkgs.follows = "nixpkgs";
    #brew-api.url = "github:BatteredBunny/brew-api";
    #brew-api.flake = false;

    # Manage a user environment using Nix
    # documentation:  https://nix-community.github.io/home-manager/
    # options search: https://mipmip.github.io/home-manager-option-search
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Externally extensible flake systems
    # documentation: https://github.com/nix-systems/nix-systems
    systems.url = "github:nix-systems/default";

    # Run macOS, Windows and more via a single Nix command, or simple nixosModules
    # documentation: https://github.com/matthewcroughan/NixThePlanet
    nixtheplanet.url = "github:matthewcroughan/NixThePlanet";
    nixtheplanet.inputs.nixpkgs.follows = "nixpkgs";

    # Build, share, and run your local development environments with a single command. Without containers.
    # documentation: https://devenv.sh/getting-started/
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    # CLI for searching packages on search.nixos.org
    nix-search.url = "github:peterldowns/nix-search-cli";
    nix-search.inputs.nixpkgs.follows = "nixpkgs";

    # no-nixpkgs standard library for the nix expression language
    # documentation: source code -> https://github.com/chessai/nix-std/
    nix-std.url = "github:chessai/nix-std";

    # Minimal Markdown Documentation
    # documentation: https://ryantm.github.io/mmdoc/
    #mmdoc.url = "github:ryantm/mmdoc";
    #mmdoc.inputs.nixpkgs.follows = "nixpkgs";

    # Atomic, declarative, and reproducible secret provisioning for NixOS based on sops.
    # documentation: https://github.com/Mic92/sops-nix
    sops-nix.url = "github:Mic92/sops-nix/master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Automate reproducible packaging for various language ecosystems
    # documentation: https://nix-community.github.io/dream2nix/
    dream2nix.url = "github:nix-community/dream2nix";
    dream2nix.inputs.nixpkgs.follows = "nixpkgs";

    # one config, multiple formats
    # documentation: https://github.com/nix-community/nixos-generators
    nixos-generators.url = "github:nix-community/nixos-generators";
    #nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # install nixos everywhere via ssh
    # documentation: https://nix-community.github.io/nixos-anywhere/
    nixos-anywhere.url = "github:numtide/nixos-anywhere/dc27d0029331cedc13f4ae346913330873847345";
    nixos-anywhere.inputs.nixpkgs.follows = "nixpkgs";

    # declarative disk partitioning
    # documentation: https://github.com/nix-community/disko/blob/master/docs/INDEX.md
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Extra home manager modules
    # documentation: https://github.com/schuelermine/xhmm
    #xhmm.url = "github:schuelermine/xhmm";

    # System-wide colorscheming and typography for NixOS and Home Manager
    # documentation: https://danth.github.io/stylix/
    #stylix.url = "github:danth/stylix";
    #stylix.inputs.nixpkgs.follows = "nixpkgs";

    # Modules and schemes to make theming with Nix awesome.
    # documentation: https://github.com/misterio77/nix-colors
    #nix-colors.url = "github:misterio77/nix-colors";

    # NixOS MicroVMs
    # documentation: https://astro.github.io/microvm.nix/
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
    #microvm.inputs.flake-utils.follows = "scripts/poetry2nix/flake-utils";

    # Multi-tenant Nix Binary Cache (runs on macOS too)
    # documentation: https://docs.attic.rs/
    attic.url = "github:zhaofengli/attic";
    attic.inputs.nixpkgs.follows = "nixpkgs";
    attic.inputs.nixpkgs-stable.follows = "nixpkgs";

    # for the Nix docker image
    #nix.url = "github:nixos/nix";
    #nix.inputs.nixpkgs.follows = "nixpkgs";

    # Combine the power of nix-eval-jobs with nix-output-monitor to speed-up your evaluation and building process
    nix-fast-build.url = "github:Mic92/nix-fast-build";
    nix-fast-build.inputs.nixpkgs.follows = "nixpkgs";

    # Finds strings in a large list of cached NixOS store paths
    #grep-nixos-cache.url = "github:delroth/grep-nixos-cache";
    #grep-nixos-cache.inputs.nixpkgs.follows = "nixpkgs";
  };

  ##################################################################################################
  ## outputs
  ##
  ## implicit attributes: outPath, rev, revCount, lastModifiedDate, lastModified, narHash
  ##
  ## introspect   -> nix flake show

  outputs =
    {
      self,
      nixpkgs,
      nixos,
      nixos-hardware,
      darwin,
      nix-homebrew,
      home-manager,
      devenv,
      ...
    }@inputs:
    let
      # System types to support.
      supportedNixSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      supportedNixosSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      supportedDarwinSystems = [
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllNixSystems = nixpkgs.lib.genAttrs supportedNixSystems;
      forAllNixosSystems = nixpkgs.lib.genAttrs supportedNixosSystems;
      forAllDarwinSystems = nixpkgs.lib.genAttrs supportedDarwinSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllNixSystems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          #overlays = [ inputs.self.overlays.default ];
        }
      );
    in
    rec {

      ##############################################################################################
      ## apps
      ##
      ##   nix run .#<name> [-- <args>]

      apps = {
        "aarch64-darwin".default = {
          type = "app";
          program = "${packages.aarch64-darwin.default}/activate";
        };
        "x86_64-linux".default = {
          type = "app";
          program = "${packages.x86_64-linux.default}/activate";
        };
      };

      ##############################################################################################
      ## packages
      ##
      ##   nix build .#<name>
      ##   nix run .#<name> [-- <args>]

      packages = forAllNixSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          hello = pkgs.hello;
          hm-activation = homeConfigurations.mbrasch-aarch64-darwin.activationPackage;
          #"x86_64-linux".default = homeConfigurations."work".activationPackage;
        }
      );

      ##############################################################################################
      ## nixcasks
      ## in config use like:
      ##    with pkgs.nixcasks; [ mpv paintbrush tor-browser ]

      #nixcasks = inputs.nixcasks.legacyPackages.aarch64-darwin;

      #nixcasks = forAllSystems ( system: let 
      #  pkgs = nixpkgsFor.${system};
      #in {
      #  inputs.nixcasks.legacyPackages;
      #});

      ##############################################################################################
      ## nixosConfigurations
      ##
      ## install:
      ##   @TODO
      ##
      ## usage:
      ##   nixos-rebuild switch --flake .#bistroserve

      nixosConfigurations = forAllNixosSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {

          installer-iso-qemu-aarch64 = inputs.nixos-generators.nixosGenerate {
            inherit system;
            modules = [ ./nixos/custom-iso.nix ];
            format = "install-iso";
          };

          installer-iso-rrz-x86_64 = inputs.nixos-generators.nixosGenerate {
            inherit system;
            modules = [ ./nixos/custom-iso.nix ];
            format = "install-iso";
          };

          bistroserve = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit pkgs inputs;
            };
            modules = [
              ./nixos/nix-nixpkgs-conf.nix
              ./nixos/bistroserve
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.mike = import ./home/mike;
                #home-manager.extraSpecialArgs = { };
              }
            ];
          };
        }
      );

      ##############################################################################################
      ## darwinConfigurations
      ##
      ## installation:
      ##   @TODO
      ##
      ## usage:
      ##   darwin-rebuild switch --flake .#mike

      darwinConfigurations = forAllDarwinSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          trillian = darwin.lib.darwinSystem {
            specialArgs = {
              inherit
                self
                system
                pkgs
                inputs
                ;
            };
            modules = [
              ./darwin/trillian
              home-manager.darwinModules.home-manager
              #nix-homebrew.darwinModules.nix-homebrew
              {
                nix-homebrew = {
                  user = "mike";
                  enable = false;
                  taps = {
                    "homebrew/homebrew-core" = inputs.homebrew-core;
                    "homebrew/homebrew-cask" = inputs.homebrew-cask;
                    "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                  };
                  mutableTaps = false;
                  autoMigrate = true;
                };
              }
              self.homeConfigurations.mike-trillian
              # {
              #   home-manager.useGlobalPkgs = true;
              #   home-manager.useUserPackages = true;
              #   home-manager.users.mbrasch = import ./home/mike;
              #   #home-manager.users.admin = import ./home/admin;
              # }
            ];
          };
        }
      );

      ##############################################################################################
      ## homeConfigurations
      ##
      ## stand-alone (darwin, NixOS and normal linux distributions)
      ##   IMPORTANT: only use each home configuration when logged in to the respective user account
      ##
      ## initial installation:
      ##   nix build .#homeConfigurations.<name>.activationPackage
      ##   ./result/activate
      ##
      ## usage:
      ##   home-manager switch --flake .#<name>

      homeConfigurations =
        let
          mkHomeConfig =
            system: username:
            home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgsFor.${system};
              extraSpecialArgs = {
                inherit inputs username;
              };
              modules = [ ./home/${username} ];
            };
        in
        {
          mike-trillian = mkHomeConfig "aarch64-darwin" "mike";
        };

      ##############################################################################################
      ## devShells
      ##
      ## nix develop [.#default] [--impure]

      devShells = forAllNixSystems (
        system:
        let
          inherit self;
          pkgs = nixpkgsFor.${system};
        in
        {
          # default = devenv.lib.mkShell {
          #   inherit inputs pkgs;
          #   modules = [
          #     (import ./devenv.nix {
          #       inherit
          #         inputs
          #         pkgs
          #         self
          #         system
          #         ;
          #     })
          #   ];
          # };
        }
      );

      ##############################################################################################
      ## checks
      ##
      ## nix check [.#default]

      # checks =  forAllNixSystems ( system: let 
      #   pkgs = nixpkgsFor.${system};
      # in {
      #   default = {};
      # });
    };
}
