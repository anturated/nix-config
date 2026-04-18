{ pkgs, awww, ... }:

{
  # TODO: quickshell
  # TODO: awww

  environment.systemPackages = [
    pkgs.cava
    pkgs.fastfetch
    pkgs.starship
    pkgs.matugen
    pkgs.quickshell
    awww

    # these are straight up themes
    pkgs.darkly-qt5
    pkgs.darkly
  ];

  # spicetify #

  programs.spicetify = {
    enable = true;
    # theme = spicetifyPkgs.themes.comfy ;
  };
}
