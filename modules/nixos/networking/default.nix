{ ... }:

{
  imports = [
    ./networkManager.nix
    ./systemd.nix
  ];

  # set in mkHost to avoid duplication
  # networking = {
  #   hostName = host;
  # };
}
