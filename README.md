# sysconfigs

## macOS

### Install

**Installing Nix**
```shell
# install the xcode command line tools
xcode-select --install

# use alternative Nix installer with activated nix-command and flakes
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

reopen shell

```shell
# test Nix installation
nix-shell -p nix-info --run "nix-info -m"
```

**Bootstrapping nix-darwin + home-manager**
```shell
# build the base configuration
nix build github:mbrasch/sysconfigs#darwinConfigurations.bootstrap-darwin.system

# delete this, otherwise darwin-rebuild will fail to create a symlink to the generated nix config
sudo rm /etc/nix/nix.conf

# create "/run" for nix-darwin and force applying
echo 'run\tprivate/var/run' | sudo tee -a /etc/synthetic.conf
/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t

# finally run apply the bootstrap configuration
./result/sw/bin/darwin-rebuild switch --flake .#bootstrap
```

reopen shell

**Apply configuration**
```shell
darwin-rebuild switch --flake github:mbrasch/sysconfigs#mbrasch
```

### Regular use

**rebuild config**
```shell
darwin-rebuild switch --flake github:mbrasch/sysconfigs#mbrasch
```

**update packages**
```shell
nix flake update github:mbrasch/sysconfigs#mbrasch
```

### Troubleshooting
sometimes a macOS update overwrites /etc/bashrc and /etc/zshrc. then you can fix it via appending:

```shell
# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
```

### Uninstall
If Nix is installed with the alternative from above:

```shell
/nix/nix-installer uninstall
```
