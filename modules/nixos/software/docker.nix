{ lib, config, ... }:

{
  config = lib.mkif config.ceirios.profiles.coding {
    virtualisation.docker.enable = true;
    systemd.services.docker.wantedBy = lib.mkForce [ ]; # Don't start on boot
    systemd.sockets.docker.wantedBy = [ "sockets.target" ]; # Start the socket instead
  };
}
