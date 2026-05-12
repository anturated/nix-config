# put it under fywion so i can just garden.fywion.nginx with the rest of them
{ self, ... }:

let
  inherit (self.lib) mkFywionOption;
in
{
  options = {
    ceirios.fywion.nginx = mkFywionOption "nginx" {
      domain = "anturated.dev";
    };
  };
}
