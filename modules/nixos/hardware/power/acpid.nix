# required for tuneD acpi stuff
{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib.modules) mkIf;

  isLaptop = config.ceirios.profiles.laptop;
in
{
  config = mkIf isLaptop {
    services.acpid.enable = true;

    ceirios.packages = { inherit (pkgs) acpi; };

    boot = {
      kernelModules = [ "acpi_call" ];
      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call
      ];
    };
  };
}
