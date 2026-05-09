{
  lib,
  self,
  config,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (self.lib) mkFywionOption;
in
{
  options.ceirios.fywion.hello-http = mkFywionOption "blahaj" { };

  config = mkIf config.ceirios.fywion.blahaj.enable {
    fywion.hello-http.enable = true;
  };
}
