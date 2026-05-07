{
  pkgs,
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.ceirios.profiles.graphical {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "volantes_cursors";
      package = pkgs.volantes-cursors;
      size = 24;
    };

    gtk = {
      enable = true;

      font = {
        name = "Cantarell 11";
        package = pkgs.cantarell-fonts;
      };

      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };

      iconTheme = {
        name = "Colloid-Grey-Nord-Dark";
        package = pkgs.colloid-icon-theme.override {
          colorVariants = [ "grey" ];
          schemeVariants = [ "nord" ];
        };
      };

      gtk4.theme = config.gtk.theme;

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    xresources.properties = {
      "Xft.dpi" = 96;
      "Xft.antialias" = true;
      "Xft.hinting" = true;
      "Xft.autohint" = false;
      "Xft.hintstyle" = "hintslight";
      "Xft.lcdfilter" = "lcddefault";
      "Xft.rgba" = "rgb";
    };
  };
}
