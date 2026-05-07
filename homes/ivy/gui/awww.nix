{
  pkgs,
  lib,
  config,
  ...
}:

{
  ceirios.packages = lib.mkIf config.ceirios.profiles.graphical {
    inherit (pkgs) awww;
  };
}
