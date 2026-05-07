{ lib, ... }:

let
  inherit (lib.modules) mkForce;
in
{
  # allow ssh into the system for headless installs
  systemd.services.sshd.wantedBy = mkForce [ "multi-user.target" ];
  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOJoauZQLAdUyxVmB+oxNQK+LSQ1Y3/L///GjC+oQlG"
  ];
}
