let
  vars = import ./_vars.nix;
in
{ ... }:
{

  # See https://wiki.hypr.land/Configuring/Window-Rules/ for more
  # See https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules
  #
  # Note: the new block windowrule {} syntax isn't supported by the HM settings attrset,
  # so this whole file stays in extraConfig.
  wayland.windowManager.hyprland.extraConfig = ''
    # floating kitty
    windowrule = float true, match:class ^(floating-kitty)$

    # nvim no blur
    windowrule = no_blur on, match:class ^(kitty)$|^(floating-kitty)$,match:title .* - Nvim

    windowrule {
      name = games
      match:class = ^(steam_app_.*)$|^(cs2)$|^(Celeste.bin.x86_64)$|^(Celeste)$|^(Streaming Client)$|^(Minecraft.*)$|^(valheim.x86_64)$|^(DREAD.*)$

      immediate = on
      fullscreen = on
      workspace = 2
    }

    windowrule {
      name = games-wayland
      match:xdg_tag = proton-game

      immediate = on
      fullscreen = on
      workspace = 2
    }

    windowrule {
      name = browser-no-borders
      match:class = ^(vivaldi-stable)$|^(zen)$

      workspace = 1
      border_size = 0
    }

    windowrule {
      name = picture-in-picture
      match:title = ^(Picture in picture)$

      float = true
      pin = true
      size = 480 270
      move = 1440 810
    }

    windowrule {
      name = discord-popout
      match:initial_title = ^Discord Popout$

      float = true
      pin = true
      size = 480 270
      move = 1440 810
    }

    windowrule {
      name = messagers
      match:class = ^(vesktop)$|^(org.telegram.desktop)$

      workspace = 3
    }

    windowrule {
      name = music-apps
      match:class = ^(spotify)$|^(ncmpcpp-custom)$

      workspace = 4
    }

    windowrule {
      name = ncmpcpp-custom
      match:class = ^(ncmpcpp-custom)$

      float = true
      size = 960 540
    }

    windowrule {
      name = game-launchers
      match:class = ^(steam)$|^(com.usebottles.bottles)$

      workspace = 5
    }

    # vlc fullscreen popup
    windowrule = move 560 986, match:class ^(vlc)$,match:title ^(vlc)$

    # other stuff
    windowrule {
      name = float-some-apps
      match:class = ^(org.gnome.Calculator)$

      float = true
    }

    windowrule {
      name = ignore-maximize
      match:class = .*

      suppress_event = maximize
    }

    # Fix some dragging issues with XWayland
    windowrule {
      name = fix-xwayland-drag
      match:class = ^$
      match:title = ^$
      match:xwayland = true
      match:float = true
      match:fullscreen = false
      match:pin = false

      no_focus = true
    }

    # bind workspaces to monitors
    workspace = 1,  monitor:${vars.mon1}, persistent:true
    workspace = 2,  monitor:${vars.mon1}, persistent:true
    workspace = 3,  monitor:${vars.mon1}, persistent:true
    workspace = 4,  monitor:${vars.mon1}, persistent:true
    workspace = 5,  monitor:${vars.mon1}, persistent:true

    workspace = 6,  monitor:${vars.mon2}
    workspace = 7,  monitor:${vars.mon2}
    workspace = 8,  monitor:${vars.mon2}
    workspace = 9,  monitor:${vars.mon2}
    workspace = 10, monitor:${vars.mon2}
  '';
}
