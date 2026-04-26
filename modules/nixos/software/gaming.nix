{
  pkgs,
  config,
  lib,
  user,
  ...
}:

let
  monitors = config.home-manager.users.${user}.machine.monitors;
  hasMonitor = monitors != [ ];
  mainMonitor = if hasMonitor then builtins.head monitors else null;
in
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # feral gamemode
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

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

  environment.systemPackages = with pkgs; [
    bottles
    ftb-app
    (prismlauncher.override {
      # Add binary required by some mod
      additionalPrograms = [ ffmpeg ];

      # Change Java runtimes available to Prism Launcher
      jdks = [
        # graalvm-ce
        graalvmPackages.graalvm-ce
        zulu8
        zulu17
        zulu
      ];
    })

    mangohud
  ];
}
