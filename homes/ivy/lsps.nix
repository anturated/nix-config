{ pkgs, ... }:

{
  # LSPs to enable system-wide
  # FIXME: there should be a better place for them.
  ceirios.packages = {
    inherit (pkgs)
      nil # for nix
      hyprls # for hypr (duh)
      lua-language-server

      # treesitter wants gcc
      gcc
      ;

    inherit (pkgs.kdePackages) qtdeclarative; # for qmlls
  };
}
