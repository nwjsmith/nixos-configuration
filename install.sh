#!/usr/bin/env bash
set -euo pipefail

# Partitioning
parted --script /dev/sda -- mklabel gpt
parted --script /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted --script /dev/sda -- set 1 esp on
parted --script /dev/sda mkpart primary ext4 512MiB 100%

# Formatting
mkfs.fat -F 32 -n boot /dev/sda1
mkfs.ext4 -q -L nixos /dev/sda2

# Installing
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

nixos-generate-config --root /mnt
