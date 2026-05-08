{ ... }:

{
  imports = [
    ./hardware.nix
  ];

  ceirios = {
    profiles = {
      headless = true;
    };

    hardware.cpu = "amd";

    networking = {
      ip = "82.38.2.58";
      gateway = "62.141.62.1";
      netmask = "255.255.255.0";
    };
  };
}
