{ user, ... }:
{
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./compositors/hyprland.nix

    ./ricing/fastfetch.nix
    ./ricing/starship.nix
    ./ricing/kitty.nix
    ./ricing/fish.nix
    ./ricing/cava.nix
    ./ricing/matugen.nix
    ./ricing/rofi.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
