{ pkgs, ... }:

{
  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  ceirios.packages = {
    inherit (pkgs)
      # these are straight up themes
      darkly-qt5
      darkly
      ;
  };
}
