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

  # autosetup network devices
  # we GIVE the installer INTERNET.
  # is this dirty? yes. but the iso has internet
  services.cloud-init.enable = true;

  # only usable with networkd
  networking = {
    useNetworkd = mkForce true;

    useDHCP = mkForce false;
    networkmanager.enable = mkForce false;
  };
}
