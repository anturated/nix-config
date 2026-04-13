{ config, lib, ... }:

let
  useAmd = config.desktop.gpu.amd;
  hasBusId = config.desktop.gpu.amdgpuBusId != "";
  busId = config.desktop.gpu.amdgpuBusId;
  quick = config.desktop.boot.quick;
in
{
  # brightness fix kinda

  # iGPU drivers
  services.xserver.videoDrivers = lib.optionals (useAmd) [
    "amdgpu"
  ];

  # should speed up the boot
  boot.initrd.kernelModules = lib.optionals (useAmd && quick) [
    "amdgpu"
  ];

  services.udev.extraRules = lib.optionals (useAmd && hasBusId) ''
    KERNEL=="card*", \
    KERNELS=="0000:${busId}", \
    SUBSYSTEM=="drm", \
    SUBSYSTEMS=="pci", \
    SYMLINK+="dri/amd-igpu"
  '';
}
