{
  pkgs,
  config,
  lib,
  ...
}:

{
  # config goes here someday
  ceirios.packages = lib.mkIf config.ceirios.profiles.graphical {
    inherit (pkgs) quickshell;
  };
}
