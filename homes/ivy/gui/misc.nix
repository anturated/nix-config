{
  pkgs,
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.ceirios.profiles.graphical {
    ceirios.packages = {
      inherit (pkgs)
        # settings
        pavucontrol
        piper

        # media viewing
        cosmic-files
        eog
        vlc
        okteta

        # tools
        coppwr
        transmission_4-gtk
        losslesscut-bin
        anydesk
        ;
    };
  };
}
