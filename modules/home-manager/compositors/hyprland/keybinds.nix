let
  vars = import ./_vars.nix;
in
{ pkgs, ... }:
{
  # See https://wiki.hypr.land/Configuring/Keywords/
  # See https://wiki.hypr.land/Configuring/Binds/
  wayland.windowManager.hyprland.extraConfig = ''
    $mainMod = ${vars.mainMod} # Sets "Windows" key as main modifier

    bind = $mainMod, U, togglesplit # dwindle
    bind = $mainMod, P, pin # dwindle

    # exec binds
    bind = $mainMod, R, exec, ${vars.terminal}
    bind = $mainMod SHIFT, R, exec, ${vars.terminal} --class=floating-kitty
    bind = $mainMod, e, exec, ${vars.terminal} yazi
    bind = $mainMod, D, exec, ${vars.menu}
    bind = $mainMod ALT, B, exec, ${vars.browser}
    bind = $mainMod, N, exec, ${vars.terminal} nvim
    bind = $mainMod ALT, T, exec, Telegram
    bind = $mainMod ALT, S, exec, steam -steamos
    bind = $mainMod ALT, D, exec, vesktop
    bind = $mainMod ALT, M, exec, spotify
    bind = $mainMod SHIFT, P, exec, ${vars.terminal} --class=ncmpcpp-custom ncmpcpp
    bind = $mainMod SHIFT, I, exec, chwal

    # bind = $mainMod SHIFT, P, exec, poweroff

    # screenshots
    bind = $mainMod SHIFT, S, exec, hyprshot -m region --freeze -o ~/Pictures/Screenshots
    bind = ALT_R, F10, exec, pkill -SIGUSR1 -f gpu-screen-reco

    bind = $mainMod SHIFT, B, global, fishy:excludeTop
    bindr = $mainMod, O, global, fishy:peekAll

    # control binds
    # bind = $mainMod  SHIFT, E, exit
    bind = $mainMod, Q, killactive
    bind = $mainMod, F, fullscreen, 1 # maximize
    bind = $mainMod SHIFT, F, fullscreen, 2 # fullscreen (like f11)

    bind = $mainMod, right, resizeactive, 100 0
    bind = $mainMod, left, resizeactive, -100 0
    bind = $mainMod, down, resizeactive, 0 100
    bind = $mainMod, up, resizeactive, 0 -100

    bind = $mainMod ALT_L, H, resizeactive, -100 0
    bind = $mainMod ALT_L, J, resizeactive, 0 100
    bind = $mainMod ALT_L, K, resizeactive, 0 -100
    bind = $mainMod ALT_L, L, resizeactive, 100 0

    bind = $mainMod SHIFT, Space, togglefloating
    bind = $mainMod, Tab, cyclenext

    # move focus
    bind = $mainMod, h, movefocus, l
    bind = $mainMod, l, movefocus, r
    bind = $mainMod, k, movefocus, u
    bind = $mainMod, j, movefocus, d

    # Move windows
    bind = $mainMod SHIFT, h, movewindow, l
    bind = $mainMod SHIFT, l, movewindow, r
    bind = $mainMod SHIFT, k, movewindow, u
    bind = $mainMod SHIFT, j, movewindow, d

    bind = $mainMod SHIFT, left,  movewindow, l
    bind = $mainMod SHIFT, right, movewindow, r
    bind = $mainMod SHIFT, up,    movewindow, u
    bind = $mainMod SHIFT, down,  movewindow, d

    # Switch workspaces with mainMod + [0-9]
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, w, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    # bind = $mainMod, 0, workspace, 10

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, w, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    # bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Example special workspace (scratchpad)
    bind = $mainMod, S, togglespecialworkspace, magic
    bind = $mainMod SHIFT, D, movetoworkspace, special:magic

    # Scroll through existing workspaces with mainMod + scroll
    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

    # Laptop multimedia keys for volume and LCD brightness
    bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
    bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    bindel = ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
    bindel = ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-

    $br_device = ${vars.brDevice}
    bindel = $mainMod, bracketright, exec, brightnessctl -e4 -n2 -d $br_device set 5%+
    bindel = $mainMod, bracketleft, exec, brightnessctl -e4 -n2 -d $br_device set 5%-

    # Requires playerctl
    bindl = , XF86AudioNext,    exec, playerctl next
    bindl = , XF86AudioPause,   exec, playerctl play-pause
    bindl = , XF86AudioPlay,    exec, playerctl play-pause
    bindl = , XF86AudioPrev,    exec, playerctl previous

    bindl = $mainMod, 0,        exec, playerctl play-pause
    bindl = $mainMod, minus,    exec, playerctl previous
    bindl = $mainMod, equal,    exec, playerctl next
  '';
}
