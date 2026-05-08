#!/usr/bin/env bash

set -euo pipefail

VERBOSE=false
if [[ "${1:-}" == "-v" ]]; then
  VERBOSE=true
fi

# wrapper
run() {
  if $VERBOSE; then
    "$@"
  else
    "$@" >/dev/null 2>&1 # TODO: collect logs and print on failure
  fi
}

echo "• ──────────────────   Ceirios ────────────────── •"
echo "  Welcome to Ceirios! (installer)"
echo "  Press Ctrl+C to cancel."
echo "• ──────────────────── System ──────────────────── •"

# get some information from the user
hostname=$(gum input \
    --header "  Enter your hostname:" \
    --header.foreground 15 \
    --placeholder "saeth" \
    --placeholder.foreground 8 \
    --prompt.foreground 8 \
    --cursor.foreground 15)
echo "  Hostname: $hostname"

drive=$(lsblk -nlo PATH,TYPE |
  awk '$2 == "disk" { print $1 }' | # choose only disks
  gum choose \
    --header "  Install to:" \
    --header.foreground 15 \
    --item.foreground 8 \
    --cursor.foreground 2)
echo "  Install to: $drive"
echo "• ──────────────────────────────────────────────── •"

# last warning
gum confirm "Wipe $drive and set up flake?" \
    --affirmative "yes" \
    --negative "no" \
    --default=false \
    --prompt.foreground 1 \
    --selected.foreground 16 \
    --selected.background 15 \
    --unselected.foreground 15 \
    --unselected.background 16 \
    --padding "0 2" \
    && echo "  Creating partitions on $drive..." \
    || exit 1

##############
#   MOUNTS   #
##############

# remove old install attempts (if there are any)
umount -R /mnt 2>/dev/null || true
swapoff -a 2>/dev/null || true

# cleanup
run wipefs -af "$drive" # fs signature
run sgdisk --zap-all "$drive" # headers

# refresh info
run partprobe "$drive"
run udevadm settle

# create some partitions
run parted -s "$drive" -- mklabel gpt
run parted -s "$drive" -- mkpart boot fat32 1MB 1024MiB
run parted -s "$drive" -- mkpart root btrfs 1024MiB -8GiB
run parted -s "$drive" -- mkpart swap linux-swap -8GiB 100%
run parted -s "$drive" -- set 1 esp on

run partprobe "$drive"
run udevadm settle

# Determine partition prefix based on drive type
if [[ $drive == *"nvme"* ]]; then
  # nvme dirves like /dev/nvme0n1p1
  echo "  Looks like nvme. Using p1-p3"
  boot_part="${drive}p1"
  root_part="${drive}p2"
  swap_part="${drive}p3"
else
  # handle /dev/sda1 style drives
  echo "  Doesn't look like nvme. Using 1-3"
  boot_part="${drive}1"
  root_part="${drive}2"
  swap_part="${drive}3"
fi

# format the partitions
echo "  Formatting..."
run mkfs.fat -F32 -n boot "$boot_part"
run mkfs.btrfs -f -L root "$root_part" # force
run mkswap -L swap "$swap_part"
run swapon "$swap_part"

# mount the partitions whilst ensuring the directories exist
echo "  Mounting..."
run mkdir -p /mnt
run mount "$root_part" /mnt
run mkdir -p /mnt/boot
run mount "$boot_part" /mnt/boot

###################
#   GIT / FLAKE   #
###################

# copy across the iso's nixos flake to the target system
echo "  Copying flake..."
run mkdir -p /mnt/etc/nixos/machines/"$hostname" # extend it all the way so we can write hw
run cp -rT /iso/flake /mnt/etc/nixos

# even if we don't need a new host we are going to have to generate a new hardware config
echo "  Generating hardware config..."
run nixos-generate-config --root /mnt --show-hardware-config >/mnt/etc/nixos/machines/"$hostname"/hardware.nix

# setup the git repository for the nixos configuration
BRANCH="master"

echo "  Setting up git repo..."
# force our branch to silence the warning
run git -C /mnt/etc/nixos init -b $BRANCH
# use https cuz i'm not adding installer keys to the repo
run git -C /mnt/etc/nixos remote add origin https://github.com/anturated/nix-config.git
(
  # grab the entire flake
  run git -C /mnt/etc/nixos fetch &&
  run git -C /mnt/etc/nixos reset "origin/HEAD" &&
  run git -C /mnt/etc/nixos branch --set-upstream-to=origin/"$BRANCH" "$BRANCH"
  # add hardware.nix if there's not one in git
  # makes nix "track" the file and shut up
  run git -C /mnt/etc/nixos add machines/"$hostname"/hardware.nix
) || true

################
#   SSH KEYS   #
################

# create ssh keys with no passphrases
echo "  Creating ssh host keys (for the new install)..."
run mkdir -p /mnt/etc/ssh
run ssh-keygen -t ed25519 -f /mnt/etc/ssh/ssh_host_ed25519_key -N ""
run ssh-keygen -t rsa -b 4096 -f /mnt/etc/ssh/ssh_host_rsa_key -N ""

###############
#   INSTALL   #
###############

# setup our installer args based off of our configuration
# this is concept is taken from https://github.com/lilyinstarlight/foosteros/blob/0d40c72ac4e81c517a7aa926b2a1fb4389124ff7/installer/default.nix
installArgs=(--no-channel-copy)
if [ "$(nix eval "/mnt/etc/nixos#nixosConfigurations.$hostname.config.users.mutableUsers")" = "false" ]; then
  installArgs+=(--no-root-password)
fi

echo "  We should be good."
echo ""
echo " ──  ──  ──  ──  To finish run this  ──  ──  ──  ── "
echo "nixos-install --flake /mnt/etc/nixos#$hostname ${installArgs[*]}"
echo " ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ── "

gum confirm "Want me to run it?" \
    --affirmative "yes" \
    --negative "no" \
    --prompt.foreground 15 \
    --selected.foreground 16 \
    --selected.background 15 \
    --unselected.foreground 15 \
    --unselected.background 16 \
    --padding "1 2" \
    --no-show-help \
&& nixos-install --flake "/mnt/etc/nixos#$hostname" "${installArgs[*]}" \
|| echo "  Ok. Run it manually then."
echo

# not really "keys" but you get the idea
# and it's symmetrical
echo " ──  ──  ──  ──  ──   SSH KEYS   ──  ──  ──  ──  ── "
cat  /mnt/etc/ssh/ssh_host_ed25519_key.pub
echo " ──  ──  ──  ──  ──   RSA KEYS   ──  ──  ──  ──  ── "
cat  /mnt/etc/ssh/ssh_host_rsa_key.pub
echo " ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ── "
echo "  This is as far as the installer goes."
echo "  MAKE SURE YOU HAVE UEFI BOOT ENABLED, NOT BIOS."
echo "  You can reboot into hard drive now."
echo "• ──────────────────────────────────────────────── •"

