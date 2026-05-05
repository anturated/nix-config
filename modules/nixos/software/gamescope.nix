{ lib, osConfig, ... }:

let
  inherit (osConfig.ceirios.hardware) monitors mainMonitor;

  mon = monitors.${mainMonitor};
in
{
  programs.gamescope = {
    enable = true;
    args = lib.mkIf (monitors != { }) [
      # window size
      "-W"
      "${toString mon.width}"
      "-H"
      "${toString mon.height}"

      # game resolution (only used in upscaling)
      # "-w"
      # "${toString mainMonitor.width}"
      # "-h"
      # "${toString mainMonitor.height}"

      # frame cap
      "-r"
      "${toString mon.refresh-rate}"

      # wayland stuff
      "--backend"
      "wayland"
      "--expose-wayland" # PROTON_ENABLE_WAYLAND analogue?

      "--mangoapp"

      # steam deck vibrancy
      "--sdr-gamut-wideness"
      "1"
    ];
  };
}
