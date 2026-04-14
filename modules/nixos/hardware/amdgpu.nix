{ config, lib, ... }:

let
  useAmd = config.machine.gpu.amd;
  hasBusId = config.machine.gpu.amd.busId != "";
  busId = config.machine.gpu.amd.busId;
  quick = config.machine.boot.quick;
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
