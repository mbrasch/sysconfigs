# configure nix and nixpkgs (when using NixOS or nix-darwin)
{
  pkgs,
  inputs,
  config,
  username,
  ...
}:
{

  # nix reference manual: https://nixos.org/manual/nix/stable/command-ref/conf-file.html
  nix = {
    package = pkgs.nixVersions.latest;
    checkConfig = true;

    settings = {
      #sandbox = true;
      #sandbox-fallback = true;
      show-trace = false;
      warn-dirty = false;
      auto-optimise-store = true;
      builders-use-substitutes = true;

      connect-timeout = 30;
      download-attempts = 5;

      extra-nix-path = "nixpkgs=${inputs.nixpkgs}";
      system-features = [
        "big-parallel"
        "kvm"
        "nixos-test"
        "apple-virt"
      ];

      experimental-features = "nix-command flakes";
    };

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      extra-platforms = x86_64-darwin aarch64-darwin
      extra-trusted-users = [ "${username}" "@admin" ]
      #access-token = ""
    '';

    # https://nixcademy.com/posts/macos-linux-builder/
    # test builder: nixos-rebuild switch --fast --target-host build02 --flake .#[nixosConf] --use-remote-sudo --use-substitutes

    linux-builder = {
      enable = true;
      ephemeral = true; # set it true if you don't want the state of the builder (caveat: no benefit from the builders build cace.)
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      mandatoryFeatures = [ ];
      maxJobs = 4;
      protocol = "ssh-ng";
      speedFactor = 1;
      supportedFeatures = [
        "benchmark"
        "big-parallel"
      ];
      workingDirectory = "/var/lib/darwin-builder";

      # nixos config for the builder. normally you should not need this option
      # when installing nix-darwin for the first time, config must be deactivated, as the default
      # linux-builder from the binary store must be installed first in order to build a custom
      # linux-builder
      config = {
        #nix.extraOptions = ''extra-platforms = x86_64-linux'';
        virtualisation = {
          darwin-builder = {
            diskSize = 40 * 1024;
            memorySize = 8 * 1024;
          };
          cores = 6;
        };
      };
    };
  };

  # nixpkgs reference manual: https://nixos.org/manual/nixpkgs/stable/#chap-packageconfig
  nixpkgs = {
    # You can add overlays here
    overlays = [
      #(import ./overrides/php81.nix)
      #(import ../pkgs)

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

      #experimental-features = config.settings.nix.experimental-features;
    };
  };
}
