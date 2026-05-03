{ host, ... }:

{
  imports = [
    ./networkManager.nix
  ];

  networking = {
    hostName = host;
  };
}
