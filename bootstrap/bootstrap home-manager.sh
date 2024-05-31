#!/bin/bash

# build configuration
nix build .#homeConfigurations.<username>.activationPackage

# apply configuration
./result/activate
