{ pkgs, ... }:

{
  qt.enable = true;

  # the one and only shell
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    kitty
    rofi
    lxqt.lxqt-policykit
  ];
}
