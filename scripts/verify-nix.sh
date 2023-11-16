#!/bin/sh

mkdir -p /tmp
nixpkgs=/tmp/nixpkgs
git clone --depth=1 https://github.com/nixos/nixpkgs $nixpkgs
rm $nixpkgs/pkgs/tools/misc/angle/default.nix
erb < distribution/nix/default.nix.erb | sponge $nixpkgs/pkgs/tools/misc/angle/default.nix

cat $nixpkgs/pkgs/tools/misc/angle/default.nix

nix-env -f $nixpkgs -iA angle
