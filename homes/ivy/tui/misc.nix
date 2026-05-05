{ pkgs, ... }:

{
  ceirios.packages = {
    inherit (pkgs)
      yazi
      btop
      lazygit
      gdu
      bluetui
      ;

    nvtop = pkgs.nvtopPackages.full;
  };
}
