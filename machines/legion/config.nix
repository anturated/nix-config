{ ... }:

{
  imports = [
    ./machine-specific/nixos/hardware-configuration.nix
    ./machine-specific/nixos/storage.nix
    ./machine-specific/nixos/users.nix
  ];

  machine = {
    isLaptop = true;
    flakeDir = "$HOME/Documents/projects/nix-config";

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

        prime = "offload";
      };
    };

    kernel = {
      lts = false;
      cachyos = {
        # enable = true;
        lto = true;
        # variant = "bore";
      };
    };

    system = {
      locale = "en_US.UTF-8";
      timeZone = "Europe/Warsaw";
    };
  };
}
