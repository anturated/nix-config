# following https://github.com/NixOS/nixpkgs/blob/77ee426a4da240c1df7e11f48ac6243e0890f03e/lib/default.nix
# as a rough template we can create our own extensible lib and expose it to the flake
# we can then use that elsewhere like our hosts
{ lib, inputs }:

lib.fixedPoints.makeExtensible (final: {
  helpers = import ./helpers.nix { inherit lib; };
  mkHost = import ./mkHost.nix { inherit inputs lib; };
  validators = import ./validators.nix { inherit lib; };

  inherit (final.helpers)
    mkPubs
    giturl
    filterNixFiles
    importNixFiles
    importNixFilesAndDirs
    boolToNum
    containsStrings
    indexOf
    intListToStringList
    ;
  inherit (final.validators)
    ifTheyExist
    anyHome
    ;
})
