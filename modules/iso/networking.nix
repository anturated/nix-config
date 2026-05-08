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

  # NOTE: for some reason dhcp is very hard to set up on my vps
  # we gotta go with networkd + cloud-init
  # if we want the vps to see the light of day ever

  # ask the host nicely for dhcp stuff
  services.cloud-init.enable = true;

  networking = {
    # use systemd-networkd
    useNetworkd = true;

    # doesn't seem to work with cloud-init
    networkmanager.enable = mkForce false;

    # just to be sure
    useDHCP = mkForce false;
  };
}
