{ config, lib, ... }:

let
  useNvidia = config.desktop.gpu.nvidia;
  hasBusId = config.desktop.gpu.nvidiaBusId != "";
  busId = config.desktop.gpu.nvidiaBusId;
  quick = config.desktop.boot.quick;
in
{

  hardware.nvidia = lib.optionals useNvidia {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true; # fixes sleep
    powerManagement.finegrained = true; # should be saving power

    # driver version
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  boot.initrd.kernelModules = lib.optionals (useNvidia && quick) [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  services.udev.extraRules = lib.optionals (useNvidia && hasBusId) ''
    # NVIDIA dGPU
    KERNEL=="card*", \
    KERNELS=="0000:${busId}", \
    SUBSYSTEM=="drm", \
    SUBSYSTEMS=="pci", \
    SYMLINK+="dri/nvidia-dgpu"
  '';
}
