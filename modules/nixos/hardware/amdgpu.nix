{ config, lib, ... }:

let
  useAmd = config.machine.gpu.amd.enable;
  hasBusId = config.machine.gpu.amd.busId != "";
  busId = config.machine.gpu.amd.busId;
  quick = config.machine.boot.quick;
  pciAddr =
    let
      parts = lib.splitString ":" busId;
    in
    "0000:${lib.fixedWidthString 2 "0" (builtins.elemAt parts 0)}"
    + ":${lib.fixedWidthString 2 "0" (builtins.elemAt parts 1)}"
    + ".${builtins.elemAt parts 2}";
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
      KERNELS=="${pciAddr}", \
      SUBSYSTEM=="drm", \
      SUBSYSTEMS=="pci", \
      SYMLINK+="dri/amd-igpu"
    '';
  };
}
