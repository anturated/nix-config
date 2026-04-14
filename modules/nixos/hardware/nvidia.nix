{ config, lib, ... }:

let
  useNvidia = config.machine.gpu.nvidia.enable;
  hasBusId = config.machine.gpu.nvidia.busId != "";
  busId = config.machine.gpu.nvidia.busId;
  quick = config.machine.boot.quick;
in
{
  config = lib.mkIf useNvidia {
    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable = true; # fixes sleep
      powerManagement.finegrained = true; # should be saving power

      # driver version
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    boot.initrd.kernelModules = lib.optionals quick [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

    services.udev.extraRules = lib.mkIf hasBusId ''
      # NVIDIA dGPU
      KERNEL=="card*", \
      KERNELS=="0000:${busId}", \
      SUBSYSTEM=="drm", \
      SUBSYSTEMS=="pci", \
      SYMLINK+="dri/nvidia-dgpu"
    '';
  };
}
