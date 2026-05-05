{ inputs, inputs', ... }:

let

  spicetifyPkgs = inputs'.spicetify.legacyPackages;
in
{
  imports = [ inputs.spicetify.homeManagerModules.spicetify ];

  # this installs spotify too probably
  programs.spicetify = {
    enable = true;
    # theme = spicetifyPkgs.themes.comfy ;
  };
}
