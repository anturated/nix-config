# See https://wiki.hypr.land/Configuring/Monitors/
{ lib, config, ... }:

let
  monitors = config.machine.monitors;
  hasMonitor = monitors != [ ];
in
{
  wayland.windowManager.hyprland.settings = {
    monitor =
      if hasMonitor then
        map (
          mon:
          (
            "${mon.name}, "
            + "${toString mon.w}x${toString mon.h}@${toString mon.hz}, "
            + "${toString mon.x}x${toString mon.y}, "
            + "${toString (mon.orientation + 1)}"
          )
        ) monitors
      else
        [ ", preferred, auto" ];
  };
}
