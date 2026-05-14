{
  pkgs,
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.ceirios.profiles.graphical {
    qt = {
      enable = true;
      platformTheme.name = "qtct";
    };

    ceirios.packages = {
      inherit (pkgs)
        # these are straight up themes
        # darkly-qt5
        darkly
        ;
    };
  };
}
