{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./tuned.nix
    ./upower.nix
  ];

  options.ceirios.profiles = {
    laptop = mkEnableOption "Enable laptop stuff";
  };
}
