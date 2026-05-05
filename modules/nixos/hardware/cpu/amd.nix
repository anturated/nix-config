{ lib, config, ... }:

let
  inherit (lib) mkIf optionals;
  inherit (config.ceirios) hardware profiles capabilities;

  useVirt = profiles.virtualization;
  hasCPPC = capabilities.CPPC;
in
{
  config = mkIf (hardware.cpu == "amd" || hardware.cpu == "amd-vm") {
    hardware.cpu.amd.updateMicrocode = true;

    boot.kernelModules = [ "amd-pstate" ] ++ optionals useVirt [ "kvm-amd" ];
    boot.kernelParams = [
      (if hasCPPC then "amd_pstate=active" else "amd_pstate=passive")
    ];
  };
}
