{ lib, config, ... }:

let
  inherit (lib) mkIf optionals;
  inherit (config.ceirios) hardware profiles;

  useVirt = profiles.virtualization;
in
{
  config = mkIf (hardware.cpu == "intel" || hardware.cpu == "intel-vm") {
    hardware.cpu.intel.updateMicrocode = true;

    boot = {
      kernelModules = optionals useVirt [ "kvm-intel" ];
      kernelParams = [
        "i915.fastboot=1"
        "enable_gvt=1"
      ];
    };
  };
}
