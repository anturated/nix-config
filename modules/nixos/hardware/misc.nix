{ config, lib, ... }:

let
  nativeBL = config.machine.isLaptop && config.machine.gpu.amd.enable;
in
{
  hardware.steam-hardware.enable = true;

  boot.kernelParams = lib.optionals nativeBL [
    "video.use_native_backlight=1"
  ];
}
