{ config, lib, ... }:

let
  useNvidia = config.machine.gpu.nvidia.enable;
  hasBusId = config.machine.gpu.nvidia.busId != "";
  busId = config.machine.gpu.nvidia.busId;
  quick = config.machine.boot.quick;
  useFinegrained = config.machine.gpu.nvidia.prime == "offload";
  pciAddr =
    let
      parts = lib.splitString ":" busId;
    in
    "0000:${lib.fixedWidthString 2 "0" (builtins.elemAt parts 0)}"
    + ":${lib.fixedWidthString 2 "0" (builtins.elemAt parts 1)}"
    + ".${builtins.elemAt parts 2}";
in
{
  config = lib.mkIf useNvidia {
    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable = true; # fixes sleep
      powerManagement.finegrained = useFinegrained; # should be saving power

      # driver version
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    boot.initrd.kernelModules = lib.optionals quick [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

    services.udev.extraRules = lib.mkIf hasBusId ''
      KERNEL=="card*", \
      KERNELS=="${pciAddr}", \
      SUBSYSTEM=="drm", \
      SUBSYSTEMS=="pci", \
      SYMLINK+="dri/nvidia-dgpu"
    '';
  };
}
