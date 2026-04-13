{ pkgs, ... }:

{
  # TODO: quickshell
  # TODO: awww

  environment.systemPackages = with pkgs; [
    cava
    fastfetch
    starship
    matugen
    quickshell

    # these are straight up themes
    darkly-qt5
    darkly
  ];

  programs.spicetify = {
    enable = true;
    # theme = spicetifyPkgs.themes.comfy ;
  };
}
