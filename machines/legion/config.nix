{ ... }:

{
  imports = [
    ./machine-specific/nixos/hardware-configuration.nix
    ./machine-specific/nixos/storage.nix
    ./machine-specific/nixos/users.nix
  ];

  desktop = {
    isLaptop = true;

    boot = {
      quick = true;
      plymouth = false;
    };

    gpu = {
      amd = {
        enable = true;
        busId = "6:0:0";
      };

      nvidia = {
        enable = true;
        busId = "1:0:0";

        prime = {
          enable = true;
          offload = true;
        };
      };
    };

    system = {
      locale = "en_US.UTF-8";
      timeZone = "Europe/Warsaw";
    };
  };
}
