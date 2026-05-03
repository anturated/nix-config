{ config, ... }:

{
  # enable non-free firmware
  hardware.enableRedistributableFirmware = true;

  # firmware updater for machine hardware
  services.fwupd = {
    enable = true;
    daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
  };
}
