{ self, ... }:

let
  template = self.lib.template.xdg;
in
{
  environment = {
    variables = template.global;

    sessionVariables = template.user template.simple;
  };
}
