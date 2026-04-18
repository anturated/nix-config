{ pkgs, pkgs-stable, ... }:

{
  qt.enable = true;

  # the one and only shell
  programs.fish.enable = true;

  environment.systemPackages = [
    pkgs-stable.neovim
    pkgs.kitty
    pkgs.rofi
    pkgs.lxqt.lxqt-policykit
  ];
}
