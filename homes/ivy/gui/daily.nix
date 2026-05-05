{ pkgs, ... }:

{
  # NOTE: these don't deserve separate modules probably
  ceirios.packages = {
    inherit (pkgs)
      vivaldi
      telegram-desktop
      anytype
      libreoffice
      ;
  };
}
