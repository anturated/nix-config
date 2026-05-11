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
        okteta

        # tools
        transmission_4-gtk
        losslesscut-bin
        ;
    };
  };
}
