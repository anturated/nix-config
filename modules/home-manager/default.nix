{ user, ... }:
{
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./ricing/fastfetch.nix
    ./ricing/starship.nix
    ./ricing/kitty.nix
    ./ricing/fish.nix
    ./ricing/cava.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
