# sysconfigs

[TOC]

## macOS

### Install

**Install Nix**

```shell
# install the xcode command line tools
xcode-select --install

# use alternative Nix installer with activated nix-command and flakes
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# open new shell
exec $SHELL

# optionally test Nix installation
nix-shell -p nix-info --run "nix-info -m"
```

**Bootstrap nix-darwin + home-manager**

```shell
# build the base configuration
nix build github:mbrasch/sysconfigs#darwinConfigurations.bootstrap.system

# delete this, otherwise darwin-rebuild will fail to create a symlink
# to the generated nix config
sudo rm /etc/nix/nix.conf

# create "/run" for nix-darwin and force applying
echo 'run\tprivate/var/run' | sudo tee -a /etc/synthetic.conf
/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t

# finally run apply the bootstrap configuration
./result/sw/bin/darwin-rebuild switch --flake .#bootstrap

# open new shell
exec $SHELL
```

**Apply configuration**

```shell
darwin-rebuild switch --flake github:mbrasch/sysconfigs#mbrasch
```

### Regular use

**rebuild config**
```shell
darwin-rebuild switch --flake github:mbrasch/sysconfigs#mbrasch
```

**update flake**

```shell
nix flake update github:mbrasch/sysconfigs#mbrasch
```

### Troubleshooting
Unfortunately, macOS always overwrites the /etc/zshrc file during updates. This is a problem insofar as the hook for Nix is here (and has to be here). To circumvent this problem, you can use a launchd job to check on every system start whether this hook still exists and rewrite it if necessary:

- copy the file [./darwin/org.nixos.darwin.check-zshrc-nix-hook.plist](./darwin/org.nixos.darwin.check-zshrc-nix-hook.plist) to `/Library/LaunchDaemons/`
- set the correct user and access rights:

```shell
sudo chown root:wheel /Library/LaunchDaemons/org.nixos.darwin.check-zshrc-nix-hook.plist
sudo chmod u=rw,go=r /Library/LaunchDaemons/org.nixos.darwin.check-zshrc-nix-hook.plist
```

- load the launchd job:

```shell
sudo launchctl load /Library/LaunchDaemons/org.nixos.darwin.check-zshrc-nix-hook.plist
```

### Uninstall

```shell
# if you have installed the launchd job `check-zshrc-nix-hook.plist`
# (from section `troubleshooting`):
sudo launchctl bootout system/org.nixos.darwin.check-zshrc-nix-hook
sudo rm /Library/LaunchDaemons/org.nixos.darwin.check-zshrc-nix-hook.plist

# if you have installed Nix via the alternative installer (mentioned in section `install`):
/nix/nix-installer uninstall
```



## Linux



## NixOS



