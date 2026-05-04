# See https://wiki.hypr.land/Configuring/Monitors/
{ osConfig, lib, ... }:

let
  inherit (osConfig.ceirios.hardware) monitors;

  hasMonitor = monitors != [ ];
in
{
  wayland.windowManager.hyprland.settings = {
    monitor =
      if hasMonitor then
        lib.mapAttrsToList (
          name: mon:
          (
            "${mon.name}, "
            + "${toString mon.width}x${toString mon.height}@${toString mon.refresh-rate}, "
            + "${toString mon.x}x${toString mon.y}, "
            + "${toString (mon.orientation + 1)}"
          )
        ) monitors
      else
        [ ", preferred, auto" ];
  };
}
