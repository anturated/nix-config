> [!CAUTION]
> WIP NOT TESTed

## Installation / Usage

```bash
git clone https://github.com/anturated/nix-config
cd nix-config
sudo nixos-rebuild switch --flake .
```

or

```bash
sudo nixos-rebuild switch --flake github:anturated/nix-config
# ^ not sure this will work tho
```

## Structure
* `hosts/` has pc-specific stuff (mounts, users, hardware-configuration), change host in flake.nix (test if can be done by command)
* `modules/nixos/` has system stuff (hardware, os, boot configs, packages)
* `modules/home-manager` has configs / dotfiles

## TODO
#### general
- [x] redo optional/config stuff as { config = lib.kmIf (...) {...} }
- [x] add custom options template
- [x] do amd/nvidia config as a top level object (nvidia.enabled, amd.busid)
- [ ] redo flake for actual multihost support
#### rice
- [ ] hyprland
- [ ] kitty
- [ ] ff
- [ ] cava
- [ ] matugen
- [ ] nvim
- [ ] rofi
- [ ] starship
- [ ] icons?
- [ ] gtk / qt themes?
- [ ] fish
- [ ] mangohud
