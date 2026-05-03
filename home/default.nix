{ user, ... }:
{
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  imports = [
    ./compositors/hyprland.nix

    ./ricing/fastfetch.nix
    ./ricing/starship.nix
    ./ricing/kitty.nix
    ./ricing/fish.nix
    ./ricing/cava.nix
    ./ricing/mangohud.nix
    ./ricing/matugen.nix
    ./ricing/rofi.nix
    ./ricing/gtk.nix
    ./ricing/qt.nix
    ./ricing/vesktop.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
