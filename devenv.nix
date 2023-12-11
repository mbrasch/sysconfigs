{ inputs, pkgs, system, self, ... } @ args: {
  name = "nixos-anywhere";
  devenv.debug = false;
  devenv.flakesIntegration = true;

  devcontainer.enable = false; # GitHub Codespaces https://github.com/features/codespaces
  difftastic.enable = true;
  languages.nix.enable = true;

  infoSections = { };

  hosts = {
    #"example.com" = "127.0.0.1";
  };

  packages = [
    inputs.sops-nix.packages.${system}.default
    inputs.nixos-anywhere.packages.${system}.nixos-anywhere
    pkgs.jq
    pkgs.sops
    pkgs.age
    pkgs.ssh-to-age
    self.packages.${system}.hello
  ];

  env = {
    FOO = "bar";
  };

  enterShell = ''
    echo "Run 'info' to get a short overview about this project"
  '';

  scripts = {
    info.exec = ''
      echo -e "to update the flake inputs, run:"
      echo -e "   nix flake update"
      echo -e ""
      echo -e "to show which outputs can be built, run:"
      echo -e "   nix flake show"
      echo -e ""
      echo -e "to bootstrap stand-alone home-manager, run:"
      echo -e "   nix build .#homeConfigurations.<name>.activationPackage"
      echo -e "   ./result/activate"
      echo -e ""
      echo -e "to rebuild the current home-manager configuration, run:"
      echo -e "   home-manager switch --flake .#<name>"
      echo -e ""
      echo -e "to bootstrap nix-darwin (optionally incl. home-manager), run:"
      echo -e "   nix build .#darwinConfigurations.bootstrap.system"
      echo -e "   sudo rm /etc/nix/nix.conf"
      echo -e "   echo 'run\\tprivate/var/run' | sudo tee -a /etc/synthetic.conf"
      echo -e "   /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t"
      echo -e "   ./result/sw/bin/darwin-rebuild switch --flake .#bootstrap"
      echo -e ""
      echo -e "   darwin-rebuild switch --flake .#<name>"
      echo -e ""
      echo -e "to rebuild the current nix-darwin configuration, run:"
      echo -e "   darwin-rebuild switch --flake .<name>"
      echo -e ""
      echo -e "to bootstrap a local NixOS from a running NixOS installer, run:"
      echo -e "   @TODO"
      echo -e ""
      echo -e "to bootstrap a NixOS configuration on a remote machine/VM (which is running a linux) run:"
      echo -e "   nixos-anywhere root@<target-ip> --flake .#<name>"
      echo -e ""
      echo -e "to rebuild the current NixOS configuration, run:"
      echo -e "   nixos-rebuild switch --flake .#<name>"
      echo -e ""
      echo -e "For more information, please consult the README.md."
    '';
  };
}
