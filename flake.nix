{
  description = "Various Nix configurations for Darwin and NixOS";

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
  };

  #################################################################################################
  ## outputs

  outputs = inputs@{ nixpkgs, nixos, nixos-hardware, darwin, home-manager, ... }: {

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
          ./darwin/configuration.nix
          home-manager.darwinModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mbrasch = import ./home/mbrasch.nix;
          }
        ];
      };
    };

    #--------------------------------------------
    # nixos

    nixosConfigurations = {

    };

  };

}