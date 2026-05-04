# NOTE: some stuff can be shared between darwin/iso/nixos/... and it should be here.
# like ssh keys and such.
# nixos-specific stuff like passwords is in modules/nixos/users/

{ lib, ... }:

let
  inherit (lib)
    submodule
    mkOption
    types
    ;
  inherit (types)

    attrsOf
    str
    ;
in
{
  imports = [
    ./mkusers.nix
  ];

  # this exists for per user overrides per machine
  # like home config, etc.
  options.ceirios.system.users = {
    type = attrsOf (
      submodule (
        { name, ... }:
        {
          options = {
            home = mkOption {
              type = str;
              default = "ivy";
              description = "Which home config to use from homes/";
              example = "ivy";
            };
          };
        }
      )
    );
  };
}
