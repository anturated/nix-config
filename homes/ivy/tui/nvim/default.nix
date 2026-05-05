{ inputs, ... }:

let
  inherit (inputs) pkgs-stable;
in
{
  # some day my config will be here...
  ceirios.packages = {
    inherit (pkgs-stable) neovim;
  };
}
