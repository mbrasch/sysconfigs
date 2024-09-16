# configure nix and nixpkgs (when using NixOS or nix-darwin)
{ pkgs, ... }:
{
  # nix reference manual: https://nixos.org/manual/nix/stable/command-ref/conf-file.html
  nix = {
    package = pkgs.nix;
    checkConfig = true;

    settings = {
      #sandbox = true;
      #sandbox-fallback = true;
      show-trace = true;
      warn-dirty = false;
      auto-optimise-store = false;
      builders-use-substitutes = true;

      http-connections = 128; # default is 25
      connect-timeout = 30;
      download-attempts = 5;
      max-substitution-jobs = 128; # default is 16

      extra-nix-path = "nixpkgs=flake:nixpkgs";
      system-features = [
        "big-parallel"
        "kvm"
      ];
      experimental-features = "nix-command flakes";
      #allowed-users = "*";
    };

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };
}
