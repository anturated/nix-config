{ pkgs, ... }:

{
  # config goes here someday
  ceirios.packages = {
    inherit (pkgs) quickshell;
  };
}
