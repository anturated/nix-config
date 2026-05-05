{ pkgs, ... }:

{
  ceirios.packages = {
    inherit (pkgs) awww;
  };
}
