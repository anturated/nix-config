{
  lib,
  config,
  ...
}:
let
  inherit (lib) elem mkIf;
in
{
  config = mkIf (elem "anturated" (builtins.attrNames config.ceirios.system.users)) {
    users.users.anturated = {
      hashedPassword = "$y$j9T$9CEup4wvJEEDXsx649flE.$9tpBeVTHGAaH4uo/qN7rE.TjqoD0wFxPdEGFILDKbU2";
    };
  };
}
