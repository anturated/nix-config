{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in
{
  options.ceirios.profiles = {
    graphical = mkEnableOption "Graphical interface";
    headless = mkEnableOption "Headless";
    workstation = mkEnableOption "Workstation";
    laptop = mkEnableOption "Laptop";
    server = mkEnableOption "Server";
  };
}
