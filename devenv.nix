{ inputs, pkgs, system, ... }: {
  devcontainer.enable = false; # GitHub Codespaces https://github.com/features/codespaces
  devenv.flakesIntegration = true;
  difftastic.enable = true;
  languages.nix.enable = true;

  hosts = {
    #"example.com" = "127.0.0.1";
  };

  packages = [
    inputs.sops-nix.packages.${system}.default
    inputs.nixos-anywhere.packages.${system}.nixos-anywhere
    pkgs.jq # use package from pkgs (defined via inputs.nixpkgs)
    pkgs.sops
    pkgs.age
    pkgs.ssh-to-age
  ];

  env = {
    FOO = "bar";
  };

  enterShell = ''
    greet
  '';

  scripts = {
    greet.exec = ''
      echo "Run 'info' to get a short overview about this project"
    '';

    info.exec = '''';
  };

  pre-commit = {
    hooks = { };
    settings = { };
  };

  processes = { };

  services = { };
}
