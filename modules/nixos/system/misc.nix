{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.ceirios.profiles.graphical {
    services = {
      # enable GVfs, a userspace virtual filesystem.
      gvfs.enable = true;

      # storage daemon required for a bunch of stuff
      udisks2.enable = true;

      dbus = {
        enable = true;
        # Use the faster dbus-broker instead of the classic dbus-daemon
        implementation = "broker";

        packages = builtins.attrValues { inherit (pkgs) dconf gcr_4 udisks; };
      };
    };
  };
}
