{ user, ... }:
{
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  imports = [
    ./cli
    ./compositors
    ./gaming
    ./gui
    ./ricing
    ./tui
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
