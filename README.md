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
* `machines/` has pc-specific stuff (mounts, users, hardware-configuration), change host in flake.nix (test if can be done by command)
* `modules/nixos/` has system stuff (hardware, os, boot configs, packages)
* `modules/home-manager` has configs / dotfiles

## TODO
#### general
- [ ] rewrite readme
- [ ] make hardware module config line
- [ ] conditional env for hyprland monitor var
- [ ] move personal programs to personal profile (telegram, vesktop, anytype, etc.)
- [ ] make program groups optional (code, etc.)
- [ ] make better program groups
- [ ] set up nix-direnv
- [ ] fix fish config auto reload
#### rice
- [x] hyprland
- [x] kitty
- [x] cava
- [x] matugen
- [ ] nvim
- [x] rofi
- [x] starship
- [x] fastfetch
- [ ] icons?
- [ ] gtk / qt themes?
- [x] fish
- [ ] mangohud
