{ lib, ... }:

{
  options.machine = {
    isLaptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    boot = {
      quick = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      plymouth = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };

    gpu = {
      amd = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        busId = lib.mkOption {
          type = lib.types.string;
          default = "";
        };
      };

      nvidia = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        busId = lib.mkOption {
          type = lib.types.string;
          default = "";
        };

        prime = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          offload = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
      };
    };

    system = {
      timezone = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      locale = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
    };
  };
}
