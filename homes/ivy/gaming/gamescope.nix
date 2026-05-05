{ lib, config, ... }:

let
  inherit (config.ceirios.hardware) monitors mainMonitor;
in
{
  programs.gamescope = {
    enable = true;
    args = lib.mkIf (monitors != { }) [
      # window size
      "-W"
      "${toString mainMonitor.width}"
      "-H"
      "${toString mainMonitor.height}"

      # game resolution (only used in upscaling)
      # "-w"
      # "${toString mainMonitor.width}"
      # "-h"
      # "${toString mainMonitor.height}"

      # frame cap
      "-r"
      "${toString mainMonitor.refresh-rate}"

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
