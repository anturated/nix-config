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
  options.ceirios.fywion.hello-http = mkFywionOption "testing" { };

  config = mkIf config.ceirios.fywion.hello-http.enable {
    fywion.hello-http.enable = true;
  };
}
