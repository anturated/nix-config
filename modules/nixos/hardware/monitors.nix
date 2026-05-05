{ lib, config, ... }:

let
  inherit (lib) mkOption types;
  inherit (types)
    str
    attrsOf
    submodule
    int
    float
    ;
in
{
  options.ceirios.hardware = {
    mainMonitor = mkOption {
      type = str;
      default = builtins.elemAt (builtins.attrNames config.ceirios.hardware.monitors) 0;
      description = "Main monitor's name.";
    };

    monitors = mkOption {
      type = attrsOf (
        submodule (
          { name, ... }:
          {
            options = {
              name = mkOption {
                type = str;
                default = name;
                description = "Monitor name";
                example = "DP-1";
              };

              width = mkOption {
                type = int;
                default = 1920;
                description = "Width of the monitor in pixels";
                example = 1920;
              };

              height = mkOption {
                type = int;
                default = 1080;
                description = "Height of the monitor in pixels";
                example = 1080;
              };

              refresh-rate = mkOption {
                type = int;
                default = 60;
                description = "Refresh rate of the monitor in hz";
                example = 144;
              };

              orientation = lib.mkOption {
                type = int;
                default = 0;
                description = "How many times the monitor is rotated 90 degrees.";
                example = 3;
              };

              x = lib.mkOption {
                type = int;
                default = 0;
                description = "Horizontal offset in pixels";
                example = -1920;
              };

              y = lib.mkOption {
                type = int;
                default = 0;
                description = "Vertical offset in pixels";
                example = 700;
              };

              scale = mkOption {
                type = float;
                default = 1.0;
                description = "Refresh rate of the monitor in hz";
                example = 1.5;
              };
            };
          }
        )
      );

      description = ''
        Declare monitors in window managers
      '';
    };
  };
}
