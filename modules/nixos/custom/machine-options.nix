{ lib, ... }:

{
  options.machine = {
    isLaptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Change to true if the device is a laptop. Used for brightness and other fixes";
    };

    boot = {
      quick = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Speeds up boot by compressing initrd, early loading modules, etc.";
      };
      plymouth = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable boot animation";
      };
    };

    gpu = {
      amd = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable AMD GPU drivers & optimizations";
        };
        busId = lib.mkOption {
          type = lib.types.string;
          default = "";
          description = "GPU bus id used for pinning gpu to a set path and offloading";
        };
      };

      nvidia = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Nvidia GPU drivers & optimizations";
        };
        busId = lib.mkOption {
          type = lib.types.string;
          default = "";
          description = "GPU bus id used for pinning gpu to a set path and offloading";
        };

        prime = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable Optimus PRIME";
          };
          offload = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable PRIME Offload";
          };
        };
      };
    };

    system = {
      timezone = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Shortcut for system.timezone nixos option";
      };
      locale = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Shortcut for system.locale nixos option";
      };
    };
  };
}
