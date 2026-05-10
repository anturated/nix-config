{
  pkgs,
  config,
  lib,
  ...
}:

{
  # LSPs to enable system-wide
  ceirios.packages = lib.mkIf config.ceirios.profiles.workstation {
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
