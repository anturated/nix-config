{ lib, ... }:

{
  options.machine.monitors = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule (
        { ... }:
        {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
            };

            x = lib.mkOption {
              type = lib.types.int;
            };

            y = lib.mkOption {
              type = lib.types.int;
            };

            w = lib.mkOption {
              type = lib.types.int;
            };

            h = lib.mkOption {
              type = lib.types.int;
            };

            hz = lib.mkOption {
              type = lib.types.int;
            };

            orientation = lib.mkOption {
              type = lib.types.int;
              default = 0;
            };
          };
        }
      )
    );

    default = [ ];
    description = "Monitor layout configuration";
  };
}
