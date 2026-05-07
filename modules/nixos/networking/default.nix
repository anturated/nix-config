{ ... }:

{
  imports = [
    ./networkManager.nix
    ./openssh.nix
    ./systemd.nix
  ];

  # set in mkHost to avoid duplication
  # networking = {
  #   hostName = host;
  # };
}
