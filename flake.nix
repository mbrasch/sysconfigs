{
  description = "Various Nix configurations for Darwin and NixOS";

  #################################################################################################
  ## nixConfig
  ##
  ## here you can configure nix specific to this project. you may (and probably will) asked for your permissions for
  ## security relevant settings.
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
    bash-prompt = "\[sysconfigs\]$ ";
    # experimental-features = [  ];    
    #buildMachines = [
    #  "ssh://root@nixos.local aarch64-linux,x86_64-linux"
    #];
    #builders-use-substitutes = true;
    extra-trusted-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  #################################################################################################
  ## inputs
  ##
  ## introspect   -> nix flake metadata
  ## update       -> nix flake update
  ##
  ## use "git+file:///to/project/path" for local references (only during development of this flake)
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    #nixpkgs.url = "github:mbrasch/nixpkgs";

    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Homebrew casks, nixified
    nixcasks.url = "github:jacekszymanski/nixcasks";
    nixcasks.inputs.nixpkgs.follows = "nixpkgs";

    # nix modules for darwin (the equivalent of NixOS modules for macOS)
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    
    # https://nix-community.github.io/home-manager claim: Manage a user environment using Nix
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    # https://devenv.sh/ claim: Build, share, and run your local development environments with a
    # single command. Without containers.
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    # CLI for searching packages on search.nixos.org
    nix-search.url = "github:peterldowns/nix-search-cli";
    nix-search.inputs.nixpkgs.follows = "nixpkgs";
    
    #piratebay.url = "github:tsirysndr/piratebay";
    #piratebay.inputs.nixpkgs.follows = "nixpkgs";
    
    #mmdoc.url = "github:ryantm/mmdoc";
    #mmdoc.inputs.nixpkgs.follows = "nixpkgs";
    
    #attic.url = "github:zhaofengli/attic";
    #attic.inputs.nixpkgs.follows = "nixpkgs";
    
    # https://github.com/Mic92/sops-nix claim: Atomic, declarative, and reproducible secret provisioning for NixOS based on sops.
    sops-nix.url = "github:Mic92/sops-nix/master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    
    # https://github.com/nix-community/dream2nix claim: Automate reproducible packaging for various language ecosystems
    #dream2nix.url = "github:nix-community/dream2nix";
    #dream2nix.inputs.nixpkgs.follows = "nixpkgs";
    
    #snowfall-lib.url = "github:snowfallorg/lib";
    #snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";
    
    #flake-root.url = "github:srid/flake-root";
    #flake-root.inputs.nixpkgs-lib.follows = "nixpkgs";
    
    # https://github.com/nix-community/nixos-generators claim: one config, multiple formats
    #nixos-generators.url = "github:nix-community/nixos-generators";
    #nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    
    # https://github.com/numtide/nixos-anywhere claim: install nixos everywhere via ssh
    nixos-anywhere.url = "github:numtide/nixos-anywhere/dc27d0029331cedc13f4ae346913330873847345";
    nixos-anywhere.inputs.nixpkgs.follows = "nixpkgs";
    
    # https://github.com/nix-community/disko claim: declarative disk partitioning
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Extra home manager modules 
    #xhmm.url = "github:schuelermine/xhmm";
    
    # System-wide colorscheming and typography for NixOS and Home Manager
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    
    # Modules and schemes to make theming with Nix awesome.
    #nix-colors.url = "github:misterio77/nix-colors";
  };

  #################################################################################################
  ## outputs
  ##
  ## introspect   -> nix flake show

  outputs = { self, nixpkgs, nixos, nixos-hardware, darwin, home-manager, devenv, ... } @inputs: 
    let      
      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in rec {
      
      ##############################################################################################################
      ## packages
      ##
      ##   nix build .#<name>
      ##   nix run .#<name> [-- <args>]
      
      packages = forAllSystems ( system: let
        pkgs = nixpkgsFor.${system};
      in {
        hello = pkgs.hello; 
      });
      
      
      ##############################################################################################################
      ## nixcasks
      ## in config use like:
      ##    with pkgs.nixcasks; [ mpv paintbrush tor-browser ]

      #nixcasks = inputs.nixcasks.legacyPackages.aarch64-darwin;

      #nixcasks = forAllSystems ( system: let 
      #  pkgs = nixpkgsFor.${system};
      #in {
      #  inputs.nixcasks.legacyPackages;
      #});


      ##############################################################################################################
      ## nixos
      ##
      ## install:
      ##   @TODO
      ##
      ## usage:
      ##   nixos-rebuild switch --flake .#bistroserve

      nixosConfigurations = forAllSystems ( system: let 
        pkgs = nixpkgsFor.${system};
      in {
        bistroserve = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit pkgs inputs; };
          modules = [
            ./nix-nixpkgs-conf.nix # nix/nixpkgs configuration for stand-alone home manager installations
            ./nixos/bistroserve
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.mbrasch = import ./home/mbrasch;
            }
          ];
        };
      });


      ##############################################################################################################
      ## nix-darwin
      ##
      ## installation:
      ##   @TODO
      ##
      ## usage:
      ##   darwin-rebuild switch --flake .#mbrasch
    
      darwinConfigurations = forAllSystems ( system: let 
        pkgs = nixpkgsFor.${system};
      in {
        mbrasch = darwin.lib.darwinSystem {
          specialArgs = { inherit pkgs inputs; };
          modules = [
            ./darwin/mbrasch
            #{
            #  home-manager.darwinModules.default    
            #  home-manager.useGlobalPkgs = true;
            #  home-manager.useUserPackages = true;
            #  home-manager.users.mbrasch = import ./home/mbrasch;
            #}
          ];
        };
      });
        
                
      ##############################################################################################################
      ## home-manager
      ##
      ## stand-alone installation:
      ##   nix build .#homeConfigurations.mbrasch.systems.aarch64-darwin.activationPackage
      ##   ./result/activate
      ##
      ## stand-alone usage:
      ##   home-manager switch --flake .#mbrasch

      homeConfigurations = forAllSystems ( system: let 
        pkgs = nixpkgsFor.${system};
      in {
        # ---------------------------------------------------------------
        mbrasch = let
          username = "mbrasch";
        in home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs username; }; 
          modules = [
            ./home/common/nix-nixpkgs-conf.nix
            ./home/${username}
          ];
        };

        # ---------------------------------------------------------------
        admin = let
          username = "admin";
        in home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs username; }; 
          modules = [
            ./home/common/nix-nixpkgs-conf.nix
            #./home/${username}
          ];
        };
      });


      ##############################################################################################################
      ## devShells
      ##
      ## nix develop [.#default] [--impure]

      devShells = forAllSystems ( system: let 
        inherit self;
        pkgs = nixpkgsFor.${system};
      in {
        default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            ( import ./devenv.nix { inherit inputs pkgs self system; } )
          ];
        };
      });
      
      
      ##############################################################################################################
      ## checks
      ##
      ## nix check [.#default]

      checks =  forAllSystems ( system: let 
        pkgs = nixpkgsFor.${system};
      in {
        default = {};
      });
      
      
    };
}
