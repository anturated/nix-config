{
  lib,
  config,
  ...
}:
let
  inherit (lib) elem mkIf;
in
{
  config = mkIf (elem "desant" (builtins.attrNames config.ceirios.system.users)) {
    users.users.desant = {
      hashedPassword = "$y$j9T$gVFMTg9bPiCeQV1QmYCW80$Sow4EyH1UCKBRYra94EY1d2DFWKxE/0ZzADroGJzg/9";
    };
  };
}
