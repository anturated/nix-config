{ lib, config, ... }:

let
  inherit (config.ceirios.system) flakeDir;
in
{
  options.ceirios.system.flakeDir = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "Path to your local config";
  };

  config.environment.variables = {
    SYSTEMD_PAGERSECURE = "true";

    # Some programs like `nh` use the FLAKE env var to determine the flake path
    FLAKE = flakeDir;
    NH_FLAKE = flakeDir;
  };
}
