{ lib, config, ... }:

let
  cfg = config.ceirios.hardware;

  hasMonitor = cfg.monitors != { };
  mainMonitor = cfg.monitors.${cfg.mainMonitor};
in
{
  programs.gamescope = {
    enable = true;
    args = lib.mkIf hasMonitor [
      # window size
      "-W"
      "${toString mainMonitor.w}"
      "-H"
      "${toString mainMonitor.h}"

      # game resolution (only used in upscaling)
      # "-w"
      # "${toString mainMonitor.w}"
      # "-h"
      # "${toString mainMonitor.h}"

      # frame cap
      "-r"
      "${toString mainMonitor.hz}"

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
