{
  inputs,
  inputs',
  lib,
  config,
  ...
}:

let
  spicetifyPkgs = inputs'.spicetify.legacyPackages;
in
{
  imports = [ inputs.spicetify.homeManagerModules.spicetify ];

  config = lib.mkIf config.ceirios.profiles.graphical {

    # this installs spotify too probably
    programs.spicetify = {
      enable = true;
      # theme = spicetifyPkgs.themes.comfy ;
    };
  };
}
