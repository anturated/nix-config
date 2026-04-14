{ config, lib, ... }:

let
  useAmd = config.machine.gpu.amd;
  hasBusId = config.machine.gpu.amd.busId != "";
  busId = config.machine.gpu.amd.busId;
  quick = config.machine.boot.quick;
in
{
  config = lib.mkIf useAmd {
    # GPU drivers
    services.xserver.videoDrivers = [
      "amdgpu"
    ];

    # should speed up the boot
    boot.initrd.kernelModules = lib.optionals quick [
      "amdgpu"
    ];

    services.udev.extraRules = lib.mkIf hasBusId ''
      KERNEL=="card*", \
      KERNELS=="0000:${busId}", \
      SUBSYSTEM=="drm", \
      SUBSYSTEMS=="pci", \
      SYMLINK+="dri/amd-igpu"
    '';
  };
}
