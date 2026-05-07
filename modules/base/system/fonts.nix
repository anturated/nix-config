{
  pkgs,
  config,
  lib,
  ...
}:

# TODO: do this properly
{
  fonts = lib.mkIf config.ceirios.profiles.graphical {
    enableDefaultPackages = true;

    packages = with pkgs; [
      # symbols #
      nerd-fonts.symbols-only
      material-symbols

      # monospace #
      monaspace
      maple-mono.CN
      iosevka
    ];
  };
}
