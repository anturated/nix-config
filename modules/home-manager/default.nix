{ ... }:

{
  _class = "homeManager";

  imports = [
    ../generic
    ./environment
    ./revision.nix
    ./profiles.nix
  ];
}
