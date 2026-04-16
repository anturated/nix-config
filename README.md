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
- [ ] make a shitload of options for cpu profiles (tlp/ppd, profile = {bat="...",ac,gam})
- [ ] move personal programs to personal profile (telegram, vesktop, anytype, etc.)
- [ ] make program groups optional (code, etc.)
- [ ] make better program groups
- [ ] set up nix-direnv
#### rice
- [ ] hyprland
- [ ] kitty
- [ ] ff
- [ ] cava
- [ ] matugen
- [ ] nvim
- [ ] rofi
- [x] starship
- [ ] icons?
- [ ] gtk / qt themes?
- [ ] fish
- [ ] mangohud
