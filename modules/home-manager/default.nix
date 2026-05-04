{ ... }:

{
  _class = "homeManager";

  imports = [
    ../generic
    ./environment
    ./fonts.nix
    ./revision.nix
    ./profiles.nix
  ];
}
