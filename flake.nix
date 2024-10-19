{
  ## for more infos about flakes, see:
  ##    https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake

  description = "Various Nix configurations for Darwin and NixOS";

  ##################################################################################################
  ##
  ##                                          # ###                             /##                      
  ##                 #                      /  /###  /                        #/ ###   #                 
  ##                ###                    /  /  ###/                        ##   ### ###                
  ##                 #                    /  ##   ##                         ##        #                 
  ##                                     /  ###                              ##                          
  ##   ###  /###   ###     /##    ###   ##   ##          /###   ###  /###    ######  ###       /###      
  ##    ###/ #### / ###   / ###  #### / ##   ##         / ###  / ###/ #### / #####    ###     /  ###  /  
  ##     ##   ###/   ##      ### /###/  ##   ##        /   ###/   ##   ###/  ##        ##    /    ###/   
  ##     ##    ##    ##       ##/  ##   ##   ##       ##    ##    ##    ##   ##        ##   ##     ##    
  ##     ##    ##    ##        /##      ##   ##       ##    ##    ##    ##   ##        ##   ##     ##    
  ##     ##    ##    ##       / ###      ##  ##       ##    ##    ##    ##   ##        ##   ##     ##    
  ##     ##    ##    ##      /   ###      ## #      / ##    ##    ##    ##   ##        ##   ##     ##    
  ##     ##    ##    ##     /     ###      ###     /  ##    ##    ##    ##   ##        ##   ##     ##    
  ##     ###   ###   ### / /       ### /    ######/    ######     ###   ###  ##        ### / ########    
  ##      ###   ###   ##/ /         ##/       ###       ####       ###   ###  ##        ##/    ### ###   
  ##                                                                                                ###  
  ##                                                                                          ####   ### 
  ##                                                                                        /######  /#  
  ##                                                                                       /     ###/      
  ##
  ## here you can configure nix options specific to this project. you may (and probably will) be
  ## asked for your permissions for security relevant settings.
  ##
  ## For the extra-substituters, you need add your username to the trusted list
  ## in /etc/nix/nix.conf. Edit this file direct
  ##
  ##      trusted-users = mike
  ##
  ## or via nix configuration)
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
  ##
  ##     #                                                          
  ##    ###                                           #             
  ##     #                                           ##             
  ##                                                 ##             
  ##   ###   ###  /###       /###   ##   ####      ######## /###    
  ##    ###   ###/ #### /   / ###  / ##    ###  / ######## / #### / 
  ##     ##    ##   ###/   /   ###/  ##     ###/     ##   ##  ###/  
  ##     ##    ##    ##   ##    ##   ##      ##      ##  ####       
  ##     ##    ##    ##   ##    ##   ##      ##      ##    ###      
  ##     ##    ##    ##   ##    ##   ##      ##      ##      ###    
  ##     ##    ##    ##   ##    ##   ##      ##      ##        ###  
  ##     ##    ##    ##   ##    ##   ##      /#      ##   /###  ##  
  ##     ### / ###   ###  #######     ######/ ##     ##  / #### /   
  ##      ##/   ###   ### ######       #####   ##     ##    ###/    
  ##                      ##                                        
  ##                      ##                                        
  ##                      ##                                        
  ##                       ##                                       
  ##
  ## introspect   -> nix flake metadata
  ## update       -> nix flake update
  ##
  ## use "git+file:///to/project/path" for local references (only during development of this flake)

  inputs = {
    # Nix Packages collection
    # documentation:  https://nixos.org/manual/nixpkgs/stable/
    #                 https://nixos.org/manual/nix/stable/
    # package search: https://search.nixos.org/packages
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    #nixpkgs.url = "github:mbrasch/nixpkgs";

    # NixOS
    # documentation:  https://nixos.org/manual/nixos/stable/
    # options search: https://search.nixos.org/options
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # nix modules for darwin (the equivalent of NixOS modules for macOS)
    # documentation: https://daiderd.com/nix-darwin
    # options:       https://daiderd.com/nix-darwin/manual
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Manage system config using nix on any linux distro
    # documentation: https://github.com/numtide/system-manager
    system-manager.url = "github:nix-systems/default";

    # Run graphics accelerated programs built with Nix on any Linux distribution.
    # documentation: https://github.com/soupglasses/nix-system-graphics
    nix-system-graphics.url = "github:soupglasses/nix-system-graphics";
    nix-system-graphics.inputs.nixpkgs.follows = "nixpkgs";

    # Manage a user environment using Nix
    # documentation:  https://nix-community.github.io/home-manager/
    # options search: https://mipmip.github.io/home-manager-option-search
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Externally extensible flake systems
    # documentation: https://github.com/nix-systems/nix-systems
    nix-systems.url = "github:nix-systems/default";

    # Homebrew installation manager for nix-darwin
    # documentation: https://github.com/zhaofengli/nix-homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;
    homebrew-bundle.url = "github:homebrew/homebrew-bundle";
    homebrew-bundle.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;

    # Modular server management based on NixOS modules and focused on best practices
    # documentation: https://shb.skarabox.com/
    #selfhostblocks.url = "github:ibizaman/selfhostblocks";

    # Snowfall Lib is a library that makes it easy to manage your Nix flake by imposing an
    # opinionated file structure.
    # documentation: https://snowfall.org/guides/lib/quickstart/
    #snowfall-lib.url = "github:snowfallorg/lib";
    #snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    # Run macOS, Windows and more via a single Nix command, or simple nixosModules
    # documentation: https://github.com/matthewcroughan/NixThePlanet
    #nixtheplanet.url = "github:matthewcroughan/NixThePlanet";
    #nixtheplanet.inputs.nixpkgs.follows = "nixpkgs";

    # Build, share, and run your local development environments with a single command. Without containers.
    # documentation: https://devenv.sh/getting-started/
    #devenv.url = "github:cachix/devenv";
    #devenv.inputs.nixpkgs.follows = "nixpkgs";

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
    xhmm.url = "github:schuelermine/xhmm";

    # System-wide colorscheming and typography for NixOS and Home Manager
    # documentation: https://danth.github.io/stylix/
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

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

    # Combine the power of nix-eval-jobs with nix-output-monitor to speed-up your evaluation and building process
    nix-fast-build.url = "github:Mic92/nix-fast-build";
    nix-fast-build.inputs.nixpkgs.follows = "nixpkgs";

    # Finds strings in a large list of cached NixOS store paths
    #grep-nixos-cache.url = "github:delroth/grep-nixos-cache";
    #grep-nixos-cache.inputs.nixpkgs.follows = "nixpkgs";

    # Install flatpaks declaratively
    # documentation: https://github.com/gmodena/nix-flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # nix2sbom extracts the SBOM (Software Bill of Materials) from a Nix derivation
    # documentation: https://github.com/louib/nix2sbom/wiki/
    nix2sbom.url = "github:louib/nix2sbom";
    nix2sbom.inputs.nixpkgs.follows = "nixpkgs";
  };

  ##################################################################################################
  ##
  ##                               #                              #             
  ##                              ##                             ##             
  ##                              ##                             ##             
  ##      /###   ##   ####      ######## /###   ##   ####      ######## /###    
  ##     / ###  / ##    ###  / ######## / ###  / ##    ###  / ######## / #### / 
  ##    /   ###/  ##     ###/     ##   /   ###/  ##     ###/     ##   ##  ###/  
  ##   ##    ##   ##      ##      ##  ##    ##   ##      ##      ##  ####       
  ##   ##    ##   ##      ##      ##  ##    ##   ##      ##      ##    ###      
  ##   ##    ##   ##      ##      ##  ##    ##   ##      ##      ##      ###    
  ##   ##    ##   ##      ##      ##  ##    ##   ##      ##      ##        ###  
  ##   ##    ##   ##      /#      ##  ##    ##   ##      /#      ##   /###  ##  
  ##    ######     ######/ ##     ##  #######     ######/ ##     ##  / #### /   
  ##     ####       #####   ##     ## ######       #####   ##     ##    ###/    
  ##                                  ##                                        
  ##                                  ##                                        
  ##                                  ##                                        
  ##                                   ##                                       
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
      nix-darwin,
      nix-homebrew,
      home-manager,
      system-manager,
      nix-system-graphics,
      #nix-flatpak,
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
      ##
      ##    .d8b.  d8888b. d8888b. .d8888. 
      ##   d8' `8b 88  `8D 88  `8D 88'  YP 
      ##   88ooo88 88oodD' 88oodD' `8bo.   
      ##   88~~~88 88~~~   88~~~     `Y8b. 
      ##   88   88 88      88      db   8D 
      ##   YP   YP 88      88      `8888Y' 
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
      ##
      ##   d8888b.  .d8b.   .o88b. db   dD  .d8b.   d888b  d88888b .d8888. 
      ##   88  `8D d8' `8b d8P  Y8 88 ,8P' d8' `8b 88' Y8b 88'     88'  YP 
      ##   88oodD' 88ooo88 8P      88,8P   88ooo88 88      88ooooo `8bo.   
      ##   88~~~   88~~~88 8b      88`8b   88~~~88 88  ooo 88~~~~~   `Y8b. 
      ##   88      88   88 Y8b  d8 88 `88. 88   88 88. ~8~ 88.     db   8D 
      ##   88      YP   YP  `Y88P' YP   YD YP   YP  Y888P  Y88888P `8888Y' 
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
          #hm-activation = homeConfigurations.mbrasch-trillian.activationPackage;
        }
      );

      ##############################################################################################
      ##
      ##   d8b   db d888888b db    db  .o88b.  .d8b.  .d8888. db   dD .d8888. 
      ##   888o  88   `88'   `8b  d8' d8P  Y8 d8' `8b 88'  YP 88 ,8P' 88'  YP 
      ##   88V8o 88    88     `8bd8'  8P      88ooo88 `8bo.   88,8P   `8bo.   
      ##   88 V8o88    88     .dPYb.  8b      88~~~88   `Y8b. 88`8b     `Y8b. 
      ##   88  V888   .88.   .8P  Y8. Y8b  d8 88   88 db   8D 88 `88. db   8D 
      ##   VP   V8P Y888888P YP    YP  `Y88P' YP   YP `8888Y' YP   YD `8888Y' 
      ##
      ## in config use like:
      ##    with pkgs.nixcasks; [ mpv paintbrush tor-browser ]

      #nixcasks = inputs.nixcasks.legacyPackages.aarch64-darwin;

      #nixcasks = forAllSystems ( system: let
      #  pkgs = nixpkgsFor.${system};
      #in {
      #  inputs.nixcasks.legacyPackages;
      #});

      ##############################################################################################
      ##
      ##   d8b   db d888888b db    db  .d88b.  .d8888. 
      ##   888o  88   `88'   `8b  d8' .8P  Y8. 88'  YP 
      ##   88V8o 88    88     `8bd8'  88    88 `8bo.   
      ##   88 V8o88    88     .dPYb.  88    88   `Y8b. 
      ##   88  V888   .88.   .8P  Y8. `8b  d8' db   8D 
      ##   VP   V8P Y888888P YP    YP  `Y88P'  `8888Y' 
      ##
      ## install:
      ##   @TODO
      ##
      ## usage:
      ##   nixos-rebuild switch --flake .#bistroserve

      # nixosConfigurations = forAllNixosSystems (
      #   system:
      #   let
      #     pkgs = nixpkgsFor.${system};
      #   in
      #   {
      #     installer-iso-qemu-aarch64 = inputs.nixos-generators.nixosGenerate {
      #       inherit system;
      #       modules = [ ./nixos/custom-iso.nix ];
      #       format = "install-iso";
      #     };

      #     installer-iso-rrz-x86_64 = inputs.nixos-generators.nixosGenerate {
      #       inherit system;
      #       modules = [ ./nixos/custom-iso.nix ];
      #       format = "install-iso";
      #     };

      #     bistroserve = nixpkgs.lib.nixosSystem {
      #       specialArgs = {
      #         inherit pkgs inputs;
      #       };
      #       modules = [
      #         ./nixos/nix-nixpkgs-conf.nix
      #         ./nixos/bistroserve
      #         home-manager.nixosModules.home-manager
      #         #nix-flatpak.nixosModules.nix-flatpak
      #         {
      #           home-manager.useGlobalPkgs = true;
      #           home-manager.useUserPackages = true;
      #           home-manager.users.mike = import ./home/mike;
      #           #home-manager.extraSpecialArgs = { };
      #         }
      #       ];
      #     };
      #   }
      # );

      ##############################################################################################
      ##
      ##   d8888b.  .d8b.  d8888b. db   d8b   db d888888b d8b   db 
      ##   88  `8D d8' `8b 88  `8D 88   I8I   88   `88'   888o  88 
      ##   88   88 88ooo88 88oobY' 88   I8I   88    88    88V8o 88 
      ##   88   88 88~~~88 88`8b   Y8   I8I   88    88    88 V8o88 
      ##   88  .8D 88   88 88 `88. `8b d8'8b d8'   .88.   88  V888 
      ##   Y8888D' YP   YP 88   YD  `8b8' `8d8'  Y888888P VP   V8P 
      ##
      ## installation:
      ##   nix run nix-darwin -- switch --flake ".[#<name>]"
      ##
      ## usage:
      ##   darwin-rebuild switch --flake ".[#<name>]""

      darwinConfigurations = {
        trillian =
          let
            hostname = "trillian";
            username = "mike";
            system = "aarch64-darwin";
          in
          nix-darwin.lib.darwinSystem {
            inherit system;
            specialArgs = {
              inherit
                self
                inputs
                username
                hostname
                ;
            };
            modules = [
              ./darwin/${hostname}
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.mike = import ./home/${username};
                home-manager.extraSpecialArgs = {
                  inherit inputs username;
                };
              }

              #nix-homebrew.darwinModules.nix-homebrew
              #{
              #  nix-homebrew = {
              #    enable = true;
              #    enableRosetta = false;
              #    mutableTaps = false; # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              #    autoMigrate = true;
              #    user = "mike";
              #
              #    # Optional: Declarative tap management
              #    taps = {
              #      "homebrew/homebrew-core" = inputs.homebrew-core;
              #      "homebrew/homebrew-cask" = inputs.homebrew-cask;
              #      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
              #    };
              #    
              #  };
              #}
            ];
          };
      };

      ##############################################################################################
      ##
      ##   .d8888. db    db .d8888. d888888b d88888b .88b  d88. 
      ##   88'  YP `8b  d8' 88'  YP `~~88~~' 88'     88'YbdP`88 
      ##   `8bo.    `8bd8'  `8bo.      88    88ooooo 88  88  88 
      ##     `Y8b.    88      `Y8b.    88    88~~~~~ 88  88  88 
      ##   db   8D    88    db   8D    88    88.     88  88  88 
      ##   `8888Y'    YP    `8888Y'    YP    Y88888P YP  YP  YP 
      ##
      ## stand-alone (macOS, NixOS and normal linux distributions)
      ##   IMPORTANT: only use each home configuration when logged in to the respective user account
      ##
      ## initial installation:
      ##   nix run 'github:numtide/system-manager' -- switch --flake '.'
      ##
      ## usage:
      ##   home-manager switch --flake .#<name>

      # systemConfigs.default = system-manager.lib.makeSystemConfig {
      #   modules = [
      #     ./modules
      #     nix-system-graphics.systemModules.default
      #     ({
      #       config = {
      #         nixpkgs.hostPlatform = "x86_64-linux";
      #         system-manager.allowAnyDistro = true;
      #         system-graphics.enable = true;
      #       };
      #     })
      #   ];
      # };

      ##############################################################################################
      ##
      ##  db   db  .d88b.  .88b  d88. d88888b 
      ##  88   88 .8P  Y8. 88'YbdP`88 88'     
      ##  88ooo88 88    88 88  88  88 88ooooo 
      ##  88~~~88 88    88 88  88  88 88~~~~~ 
      ##  88   88 `8b  d8' 88  88  88 88.     
      ##  YP   YP  `Y88P'  YP  YP  YP Y88888P 
      ##
      ## stand-alone (macOS, NixOS and normal linux distributions)
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
          mike-tuxedo = mkHomeConfig "x86_64-linux" "mike";
          mike-linuxvm = mkHomeConfig "aarch64-linux" "mike";
        };

      ##############################################################################################
      ##
      ##   d8888b. d88888b db    db .d8888. db   db d88888b db      db      .d8888. 
      ##   88  `8D 88'     88    88 88'  YP 88   88 88'     88      88      88'  YP 
      ##   88   88 88ooooo Y8    8P `8bo.   88ooo88 88ooooo 88      88      `8bo.   
      ##   88   88 88~~~~~ `8b  d8'   `Y8b. 88~~~88 88~~~~~ 88      88        `Y8b. 
      ##   88  .8D 88.      `8bd8'  db   8D 88   88 88.     88booo. 88booo. db   8D 
      ##   Y8888D' Y88888P    YP    `8888Y' YP   YP Y88888P Y88888P Y88888P `8888Y' 
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
      ##
      ##    .o88b. db   db d88888b  .o88b. db   dD .d8888. 
      ##   d8P  Y8 88   88 88'     d8P  Y8 88 ,8P' 88'  YP 
      ##   8P      88ooo88 88ooooo 8P      88,8P   `8bo.   
      ##   8b      88~~~88 88~~~~~ 8b      88`8b     `Y8b. 
      ##   Y8b  d8 88   88 88.     Y8b  d8 88 `88. db   8D 
      ##    `Y88P' YP   YP Y88888P  `Y88P' YP   YD `8888Y' 
      ##
      ## nix check [.#default]

      # checks =  forAllNixSystems ( system: let
      #   pkgs = nixpkgsFor.${system};
      # in {
      #   default = {};
      # });
    };
}
