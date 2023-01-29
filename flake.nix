{
  description = "Various Nix configurations for Darwin and NixOS";

  #################################################################################################
  ## inputs

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  #################################################################################################
  ## outputs

  outputs = inputs@{ nixpkgs, home-manager, darwin, darwin-modules, ... }: {

    #--------------------------------------------
    # darwin

    darwinConfigurations = {
      mbrasch = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin/configuration.nix
          home-manager.darwinModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mbrasch = import ./home;
          }
        ];
      };
    };
  };

}