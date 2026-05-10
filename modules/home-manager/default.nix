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
    ./secrets.nix
  ];
}
