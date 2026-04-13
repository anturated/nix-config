{ host, ... }:

{
  imports = [
    ./hardware/amdgpu.nix
    ./hardware/bluetooth.nix
    ./hardware/firmware.nix
    ./hardware/misc.nix
    ./hardware/nvidia.nix
    ./hardware/prime.nix

    ./software/core.nix
    ./software/code.nix
    ./software/gaming.nix
    ./software/util.nix

    ./system/boot.nix
    ./system/display.nix
    ./system/env.nix
    ./system/fonts.nix
    ./system/greet.nix
  ];

  # enable spyware
  nixpkgs.config.allowUnfree = true;
  # very dangerous bleeding edge stuff here
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "${host}";
  networking.networkmanager.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  system.stateVersion = "25.05"; # DONT CHANGE
}
