{ ... }:

{
  _class = "homeManager";

  imports = [
    ../generic
    ./fonts.nix
    ./environment
    ./extras.nix
    ./revision.nix
    ./profiles.nix
    ./software
    ./secrets.nix
  ];
}
