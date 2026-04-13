{ pkgs, ... }:

{
  users.users.desant = {
    isNormalUser = true;
    description = "plants plants.";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "input"
      "uinput"
      "gamemode"
    ];
    shell = pkgs.fish;
  };
}
