{
  pkgs,
  config,
  lib,
  ...
}:

{
  ceirios.packages = {
    inherit (pkgs)
      # these are just nice to have
      yazi
      btop
      gdu
      ;
  }
  // lib.optionalAttrs config.ceirios.profiles.graphical {
    inherit (pkgs) bluetui;
    nvtop = pkgs.nvtopPackages.full;
  };
}
