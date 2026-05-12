{ ... }:

{
  imports = [
    ./hardware.nix
  ];

  ceirios = {
    profiles.headless = true;

    hardware.cpu = "amd";

    networking = {
      interface = "eth0";
      ip = "178.105.140.238";
      gateway = "172.31.1.1";
      ip6 = "2a01:4f8:1c18:ca88::/64";
      gateway6 = "fe80::1";
      netmask = "255.255.255.255";
    };

    system.users.anturated = { };

    fywion = {
      nginx.enable = true;
      anturated-website.enable = true;
      mailserver.enable = true;
    };
  };
}
