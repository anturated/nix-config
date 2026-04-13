{ config, lib, ... }:

let
  nativeBL = config.desktop.isLaptop && config.desktop.gpu.amd;
in
{
  hardware.steam-hardware.enable = true;

  boot.kernelParams = lib.optionals (nativeBL) [
    "video.use_native_backlight=1"
  ];
}
