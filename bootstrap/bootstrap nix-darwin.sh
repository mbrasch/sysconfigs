#!/bin/bash

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
