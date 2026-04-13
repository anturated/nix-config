{ ... }:
{
  imports = [
    ./host-specific/nixos/hardware-configuration.nix
    ./host-specific/nixos/storage.nix
    ./host-specific/nixos/users.nix
  ];

  desktop = {
    isLaptop = true;

    boot = {
      quick = true;
      plymouth = false;
    };

    gpu = {
      # drivers etc.
      amd = true;
      amdgpuBusId = "PCI:6:0:0";
      nvidia = true;
      nvidiaBusId = "PCI:1:0:0";

      prime = {
        enable = true;
        offload = true;
      };
    };

    system = {
      locale = "en_US.UTF-8";
      timeZone = "Europe/Warsaw";
    };
  };
}
