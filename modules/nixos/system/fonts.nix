{ pkgs, ... }:
{
  fonts = {
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
