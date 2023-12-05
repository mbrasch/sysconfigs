{ inputs, pkgs, system, self, ... }@args: {
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
    hello
    echo "Run 'info' to get a short overview about this project"
  '';

  scripts = {
    info.exec = ''
      echo "s could be an infotext"
    '';
  };
}
