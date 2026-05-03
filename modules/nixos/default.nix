{ ... }:

{
  _class = "nixos";

  imports = [
    ../base
    ./boot
    ./hardware
    ./scripts
    ./system
  ];
}
