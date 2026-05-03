{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in
{
  options.ceirios.profiles = {
    laptop = mkEnableOption "Enable laptop stuff";
  };
}
