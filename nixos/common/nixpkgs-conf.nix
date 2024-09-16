# configure nix and nixpkgs (when using NixOS or nix-darwin)
{ pkgs, ... }:
{
  # nixpkgs reference manual: https://nixos.org/manual/nixpkgs/stable/#chap-packageconfig
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      #outputs.overlays.additions
      #outputs.overlays.modifications
      #outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      #neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      #(final: prev: {
      #  hi = final.hello.overrideAttrs (oldAttrs: {
      #    patches = [ ./change-hello-to-hi.patch ];
      #  });
      #})
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = true;

      # Workaround for https://github.com/nix-community/home-manager/issues/2942#issuecomment-1378627909
      # and https://discourse.nixos.org/t/nixpkgs-unfree-configs-not-respected/20546/9
      allowUnfreePredicate = (_: true);

      experimental-features = "nix-command flakes";
    };
  };
}
