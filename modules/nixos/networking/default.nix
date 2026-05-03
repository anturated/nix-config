{ host, ... }:

{
  imports = [
    ./networkManager.nix
    ./systemd.nix
  ];

  networking = {
    hostName = host;
  };
}
