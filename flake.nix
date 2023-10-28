{
  description = "Various Nix configurations for Darwin and NixOS";

  #################################################################################################
  ## nixConfig
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
    experimental-features = [ "nix-command" "flakes" ];
    
    substituters = [
      # Replace the official cache with a mirror located in China
      #"https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
  
    extra-substituters = [
      # Nix community's cache server
      "https://nix-community.cachix.org"
    ];
    
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  #################################################################################################
  ## inputs

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    # https://devenv.sh/ claim: Build, share, and run your local development environments with a single command. Without containers.
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    # CLI for searching packages on search.nixos.org
    nix-search.url = "github:peterldowns/nix-search-cli";
    nix-search.inputs.nixpkgs.follows = "nixpkgs";
    
    piratebay.url = "github:tsirysndr/piratebay";
    piratebay.inputs.nixpkgs.follows = "nixpkgs";
    
    mmdoc.url = "github:ryantm/mmdoc";
    mmdoc.inputs.nixpkgs.follows = "nixpkgs";
    
    attic.url = "github:zhaofengli/attic";
    attic.inputs.nixpkgs.follows = "nixpkgs";
    
    # https://github.com/Mic92/sops-nix claim: Atomic, declarative, and reproducible secret provisioning for NixOS based on sops.
    sops-nix.url = "github:Mic92/sops-nix/master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    
    # https://github.com/nix-community/dream2nix claim: Automate reproducible packaging for various language ecosystems
    dream2nix.url = "github:nix-community/dream2nix";
    dream2nix.inputs.nixpkgs.follows = "nixpkgs";
    
    # https://flake.parts claim: Simplify Nix Flakes with the module system
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    
    #flake-root.url = "github:srid/flake-root";
    #flake-root.inputs.nixpkgs-lib.follows = "nixpkgs";
    
    # https://github.com/nix-community/nixos-generators claim: one config, multiple formats
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    
    # https://github.com/numtide/nixos-anywhere claim: install nixos everywhere via ssh
    nixos-anywhere.url = "github:numtide/nixos-anywhere/dc27d0029331cedc13f4ae346913330873847345";
    nixos-anywhere.inputs.nixpkgs.follows = "nixpkgs";
    
    # https://github.com/nix-community/disko claim: declarative disk partitioning
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Extra home manager modules 
    xhmm.url = "github:schuelermine/xhmm";
    
    # System-wide colorscheming and typography for NixOS and Home Manager
    #stylix.url = "github:danth/stylix";
    #stylix.inputs.nixpkgs.follows = "nixpkgs";
    
    # Modules and schemes to make theming with Nix awesome.
    #nix-colors.url = "github:misterio77/nix-colors";
  };

  #################################################################################################
  ## outputs

  outputs = { self, nixpkgs, nixos, nixos-hardware, darwin, home-manager, devenv, ... } @inputs: 
    let
      inherit (self) outputs;
      
    in {
      #--------------------------------------------
      # home-manager
      
      homeConfigurations.mbrasch = let 
        username = "mbrasch";
        system = "aarch64-darwin";
      in
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs outputs username; };
      
          modules = [
            ./nix-nixpkgs-conf.nix # nix/nixpkgs configuration for stand-alone home manager installations
            ./home/${username}
          ];
        };
        
      #--------------------------------------------
      # darwin
  
      darwinConfigurations = {
        bootstrap = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
          ];
        };
  
        mbrasch = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin/mbrasch
            home-manager.darwinModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.mbrasch = import ./home/mbrasch;
            }
          ];
        };
      };
      
      
      
      #################################################################################################################
      ## perSystem: the particular configuration is built for the system architecture on which it is built
      ##
      ## perSystem.<packages|apps|checks|debug|devShells|formatter|legacyPackages|overlayAttrs>
      
      perSystem = { self', inputs', config, pkgs, system, modulesPath, ... }: {
        #_module.args.pkgs = inputs'.nixpkgs.legacyPackages; # make pkgs available to all `perSystem` functions
        #_module.args.lib = lib; # make custom lib available to all `perSystem` functions
      
        ###############################################################################################################
        ## devShells
      
        # nix develop [default]
        devShells = {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
              (import ./devenv.nix {inherit inputs pkgs system;})
            ];
          };
        };
      };
  };
}
