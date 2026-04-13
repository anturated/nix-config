{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      # symbols #
      # TODO: there's better nerd fonts fr fr
      nerd-fonts.meslo-lg
      material-symbols

      # monospace #
      monaspace
      maple-mono.CN
      iosevka
    ];
  };
}
