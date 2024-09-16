# configure nix and nixpkgs (when using NixOS or nix-darwin)
{ pkgs, inputs, ... }:
{
  # nix reference manual: https://nixos.org/manual/nix/stable/command-ref/conf-file.html
  nix = {
    package = pkgs.nixVersions.latest;
    checkConfig = true;

    settings = {
      #sandbox = true;
      #sandbox-fallback = true;
      show-trace = true;
      warn-dirty = false;
      auto-optimise-store = false;
      builders-use-substitutes = true;

      connect-timeout = 30;
      download-attempts = 5;

      extra-nix-path = "nixpkgs=${inputs.nixpkgs}";
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
