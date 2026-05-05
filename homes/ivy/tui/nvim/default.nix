{ pkgsStable, ... }:

{
  # some day my config will be here...
  ceirios.packages = {
    inherit (pkgsStable) neovim;
  };
}
