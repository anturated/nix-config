{ ... }:

{
  _class = "homeManager";

  imports = [
    ../generic
    ./environment
    ./extras.nix
    ./revision.nix
    ./profiles.nix
    ./software
    ./defaults.nix
    ./secrets.nix
  ];
}
