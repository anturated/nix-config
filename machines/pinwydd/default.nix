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
  };
}
