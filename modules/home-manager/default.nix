{ user, ... }:
{
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  nixpkgs.config.allowUnfree = true;

  imports = [
  ];

  home.stateVersion = "25.05";
}
