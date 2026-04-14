{ config, lib, ... }:

let
  mode = config.machine.gpu.nvidia.prime;
  amdBusId = config.machine.gpu.amd.busId;
  nvBusId = config.machine.gpu.nvidia.busId;

  enabled = mode != "disable";
in
{
  config = lib.mkIf enabled {
    assertions = [
      {
        assertion = amdBusId != "" && nvBusId != "";
        message = "PRIME requires both machine.gpu.amd.busId and machine.gpu.nvidia.busId to be set";
      }
    ];

    hardware.nvidia.prime = {
      amdgpuBusId = "PCI:${amdBusId}";
      nvidiaBusId = "PCI:${nvBusId}";

      sync.enable = mode == "sync";
      reverseSync.enable = mode == "reverse-sync";
      offload.enable = mode == "offload";
      offload.enableOffloadCmd = mode == "offload";
    };
  };
}
