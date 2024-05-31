# sysconfigs

[TOC]

## introduction

@TODO

---

## install Nix

(for macOS and Linux)

I use the [DetSys Nix installer](https://zero-to-nix.com/start/install) here. Firstly because it is easier to uninstall and secondly because the experimental features "nix-command" and "flakes" are active by default. Nix can of course also be installed from the [original installer](https://nixos.org/download/). (But then don't forget to activate the two experimental features).

```shell
# macOS only: install the xcode command line tools
xcode-select --install

# use alternative Nix installer with activated nix-command and flakes
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# open new shell
exec $SHELL

# optionally test Nix installation
nix-shell -p nix-info --run "nix-info -m"
```

### macOS: fix the problem with the missing Nix hook after system updates

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

### regular use

Using Nix only as a package manager is very like using imperative package manager like apt.

**search for a package**

```shell
nix search <search string>
```

**install a package**

```shell
nix profile install <package>
```

**list installed packages**

```shell
nix profile list
```

**remove a package**

```shell
nix profile remove <package>
```

**update packages**

```shell
nix profile update <package>
```

### Uninstall

If Nix was installed via the original installer, manual work is required. More on this in the [Nix manual](https://nix.dev/manual/nix/2.22/installation/uninstall). If the DetSys installer was used, it is easy:

```shell
# if you have installed the launchd job `check-zshrc-nix-hook.plist`
# (from section `troubleshooting`):
sudo launchctl bootout system/org.nixos.darwin.check-zshrc-nix-hook
sudo rm /Library/LaunchDaemons/org.nixos.darwin.check-zshrc-nix-hook.plist

# if you have installed Nix via the alternative installer (mentioned in section `install`):
/nix/nix-installer uninstall
```



---

## clone this repo

(for macOS, Linux and NixOS)

### clone this repo

the destination directory depends on the specific case. @TODO

- for home-manager stand-alone: `~/.config/home-manager`
- for nix-darwin (incl. home-manager): `@TODO`
- for NixOS (incl. home-manager): `/etc/nixos`

```shell
git clone git@github.com:mbrasch/sysconfigs.git <destination>
```

### customize configuration

 :warning: you need to adjust some values in `./flake.nix`:

- `username` and `system` in `homeConfigurations.<username>`. The `username` must be equal to your username on your system. In in this configuration, it is assumed that the home folder is named like the username.
- `hostname` in `darwinConfiguration.<hostname>`. The `hostname` should be equal to the hostname of your system.



---

## home-manager stand-alone

(for macOS, Linux, NixOS)

### bootstrap

```shell
# build configuration
nix build .#homeConfigurations.<username>.activationPackage

# apply configuration
./result/activate
```

### regular use

**update flake**

```shell
nix flake update github:mbrasch/sysconfigs#mbrasch
```

**rebuild config**

```shell
home-manager switch
```

**list all packages installed in `home-manager-path`**

```shell
home-manager packages
```

**list all home manager generations**

```shell
home-manager generations
```

**rollback to a previous generation**

```shell
# list generations
home-manager generations
# copy the full store path of the desired generation out of the list
# paste it to the terminal and tab-autocomplete it to the activation script
/nix/store/<some-hash>/activate
```

**remove generations by IDs**

```shell
# get the IDs via generations subcommand
home-manager remove-generations <id 1> <id 2> …
```

**remove generations older than n days or before a specific date**

```shell
home-manager expire-generations [ -n days | yyyy-mm-dd ]
```

### uninstall home manager

remove home manager from the user environment. this will

- remove all managed files from the home directory,         
- remove packages installed through Home Manager from the user profile, and         
- remove all Home Manager generations and make them available for immediate garbage collection.         

```shell
home-manager uninstall
```



---

## nix-darwin (optionally with home-manager)

(for macOS only)

### bootstrap

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

### regular use

**apply configuration changes**

```shell
darwin-rebuild switch --flake github:mbrasch/sysconfigs#mbrasch
```



---

## NixOS

### bootstrap

```shell

```

### regular use

**apply configuration changes**

```shell
nixos-rebuild switch --flake github:mbrasch/sysconfigs#mbrasch
```

