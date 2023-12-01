# sysconfigs

[TOC]

## macOS

### Install Nix

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

### clone the repo

clone repo and copy its contents to ~/.config/home-manager

```shell
git clone ssh://azdops.serviceware.net:22/sw/Platform/Operations/_git/poc-nix-homemanager
mkdir -p ~/.config/home-manager
cp -R poc-nix-homemanager  ~/.config/home-manager
```

### customize configuration

 :warning:: you need to adjust the `username` and `system` in `./flake.nix`-> homeConfigurations.<username>. The `username` must be equal to your username on your system. In in this configuration, it is assumed that the home folder is named like the username. 

### home-manager stand-alone

#### Bootstrap

Build configuration

```shell
nix build .#homeConfigurations.<username>.activationPackage
```

Apply configuration

```shell
./result/activate
```



### nix-darwin (optionally with home-manager)

#### Bootstrap

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

Apply configuration

```shell
darwin-rebuild switch --flake github:mbrasch/sysconfigs#mbrasch
```

### Regular use

**update flake**

```shell
nix flake update github:mbrasch/sysconfigs#mbrasch
```

**rebuild config**

nix-darwin (optionally with home-manager)

```shell
darwin-rebuild switch --flake github:mbrasch/sysconfigs#mbrasch
```

home-manager stand-alone

```shell
home-manager switch
```

#### list installed packages

list all packages installed in `home-manager-path`.

```shell
home-manager packages
```



#### generations

#### list all home manager generations

```shell
home-manager generations
```

#### rollback to a previous generation

```shell
# list generations
home-manager generations
# copy the full store path of the desired generation out of the list
# paste it to the terminal and tab-autocomplete it to the activation script
/nix/store/<some-hash>/activate
```

#### remove generations by IDs

```shell
# get the IDs via generations subcommand
home-manager remove-generations <id 1> <id 2> …
```

#### remove generations older than n days or before a specific date

```shell
home-manager expire-generations [ -n days | yyyy-mm-dd ]
```



#### uninstall home manager

remove home manager from the user environment. this will

- remove all managed files from the home directory,         
- remove packages installed through Home Manager from the user profile, and         
- remove all Home Manager generations and make them available for immediate garbage collection.         

```shell
home-manager uninstall
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



