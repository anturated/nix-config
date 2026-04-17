{ ... }:
{
  wayland.windowManager.hyprland = {
    settings = {
      # https://wiki.hypr.land/Configuring/Variables/#input
      input = {
        kb_layout = "us,ru,pl,ua";
        kb_variant = "";
        kb_model = "";
        kb_options = "grp:alt_shift_toggle";
        kb_rules = "";

        follow_mouse = 1;

        sensitivity = -0.55; # -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat";

        touchpad = {
          natural_scroll = true;
        };
      };
    };

    extraConfig = ''
      # https://wiki.hypr.land/Configuring/Variables/#gestures
      gestures {
          # workspace_swipe = true
          gesture = 3, vertical, workspace
      }

      # Example per-device config
      # See https://wiki.hypr.land/Configuring/Keywords/#per-device-input-configs for more
      # device {
      #     name = logitech-g-pro-wireless-gaming-mouse-2
      #     sensitivity = -0.55
      #     accel_profile = "flat"
      # }

      device {
          name = msft0001:00-04f3:3186-touchpad
          sensitivity = 0
          accel_profile = adaptive
      }
    '';
  };
}
