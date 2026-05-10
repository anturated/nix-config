{ inputs', ... }:

{
  # some day my config will be here...
  ceirios.packages = {
    # using stable so plugins catch up and don't break
    inherit (inputs'.nixpkgs-stable.legacyPackages) neovim;
  };
}
