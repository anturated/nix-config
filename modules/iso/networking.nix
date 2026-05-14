{ lib, ... }:

let
  inherit (lib.modules) mkForce;
in
{
  # allow to ssh on installer

  # start sshd
  systemd.services.sshd.wantedBy = mkForce [ "multi-user.target" ];

  # add our key to root
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOJoauZQLAdUyxVmB+oxNQK+LSQ1Y3/L///GjC+oQlG"
  ];
}
