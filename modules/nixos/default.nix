{ host, config, ... }:

{
  imports = [
    ./custom/machine-options.nix
    ./custom/kernel-options.nix

    ./hardware/amdgpu.nix
    ./hardware/bluetooth.nix
    ./hardware/firmware.nix
    ./hardware/misc.nix
    ./hardware/nvidia.nix
    ./hardware/prime.nix

    ./scripts/chwal.nix
    ./scripts/kale.nix
    ./scripts/kaled.nix
    ./scripts/rebuild.nix

    ./software/code.nix
    ./software/core.nix
    ./software/daily.nix
    ./software/gaming.nix
    ./software/ricing.nix
    ./software/services.nix
    ./software/util.nix

    ./system/boot.nix
    ./system/display.nix
    ./system/env.nix
    ./system/fonts.nix
    ./system/greet.nix
    ./system/kernel.nix
  ];

  # enable spyware
  nixpkgs.config.allowUnfree = true;
  # very dangerous bleeding edge stuff here
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly"; # or "daily"
    options = "--delete-older-than 7d";
  };

  #  auto-optimize store
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  networking.hostName = "${host}";
  networking.networkmanager.enable = true;

  time.timeZone = "${config.machine.system.timeZone}";
  i18n.defaultLocale = "${config.machine.system.locale}";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  system.stateVersion = "25.05"; # DONT CHANGE
}
