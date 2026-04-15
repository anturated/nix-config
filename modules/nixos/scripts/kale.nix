{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "kale" ''
      #!/usr/bin/env bash

      MY_PID=$$

      # defaults
      USE_HYPR=1
      USE_OFFLOAD=1
      USE_GAMEMODE=1
      USE_GAMEMODE_DAEMON=0
      USE_MANGOHUD=1
      USE_POWER=1
      USE_PROTON_WAYLAND=1
      USE_PROTON_LOG=0
      USE_STEAMDECK=0

      # check flags
      while getopts ":mgGnCHOMPlsx" opt; do
        FLAGS_SET=1
        case $opt in
          m) # minimal
            USE_HYPR=0
            USE_MANGOHUD=0
            USE_POWER=0
            USE_PROTON_WAYLAND=0
            ;;
          # env vars
          x) USE_PROTON_WAYLAND=0 ;;
          l) PROTON_LOG=1 ;;
          s) USE_STEAMDECK=1 ;;
          g) # gamemode daemon
            USE_GAMEMODE=0
            USE_GAMEMODE_DAEMON=1
            ;;
          G) # gamemode both
            USE_GAMEMODE=1
            USE_GAMEMODE_DAEMON=1
            ;;
          n) # no gamemode
            USE_GAMEMODE=0
            USE_GAMEMODE_DAEMON=0
            ;;
          c) # customize
            USE_HYPR=0
            USE_OFFLOAD=0
            USE_GAMEMODE=0
            USE_GAMEMODE_DAEMON=0
            USE_MANGOHUD=0
            USE_POWER=0
          ;;
          H) USE_HYPR=1 ;;
          O) USE_OFFLOAD=1 ;;
          M) USE_MANGOHUD=1 ;;
          P) USE_POWER=1 ;;
          *) ;;
        esac
      done
      shift $((OPTIND -1))

      # cleanup trap
      GM_PID=""
      cleanup() {
        if [ -n "$GM_PID" ]; then
          kill "$GM_PID" 2>/dev/null || true
        fi
        if [ $USE_POWER -eq 1 ]; then
          dbus-send --system --print-reply \
                    --dest=com.anturated.kaled \
                    /com/anturated/kaled com.anturated.kaled.UnregisterClient \
                    int32:$MY_PID
        fi
        if [ $USE_HYPR -eq 1 ]; then
          ${pkgs.hyprland}/bin/hyprctl reload
        fi
      }
      trap cleanup EXIT

      # remove hyprland beauty in favor of the frames
      if [ $USE_HYPR -eq 1 ]; then
        ${pkgs.hyprland}/bin/hyprctl keyword animations:enabled 0
        ${pkgs.hyprland}/bin/hyprctl keyword decoration:blur:enabled 0
        ${pkgs.hyprland}/bin/hyprctl keyword render:direct_scanout 1
      fi

      # apply power profiles
      if [ $USE_POWER -eq 1 ]; then
        dbus-send --system --print-reply \
                  --dest=com.anturated.kaled \
                  /com/anturated/kaled com.anturated.kaled.RegisterClient \
                  int32:$MY_PID
      fi

      # pop a gamemode daemon (nightreign stare)
      if [ $USE_GAMEMODE_DAEMON -eq 1 ]; then
        ${pkgs.gamemode}/bin/gamemoded -r &
        GM_PID=$!
      fi

      # assemble #
      CMD=("$@")
      ENV_VARS=()

      # proton / steam env
      [ $USE_PROTON_WAYLAND -eq 1 ] && ENV_VARS+=("PROTON_ENABLE_WAYLAND=1")
      [ $USE_PROTON_LOG -eq 1 ] && ENV_VARS+=("PROTON_LOG=1")
      [ $USE_STEAMDECK -eq 1 ] && ENV_VARS+=("SteamDeck=1")

      # nvidia offload
      if [ $USE_OFFLOAD -eq 1 ]; then
        ENV_VARS+=(
          "__NV_PRIME_RENDER_OFFLOAD=1"
          "__NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0"
          "__GLX_VENDOR_LIBRARY_NAME=nvidia"
          "__VK_LAYER_NV_optimus=NVIDIA_only"
        )
      fi

      # apply env in one go
      if [ ''${#ENV_VARS[@]} -gt 0 ]; then
        CMD=(env "''${ENV_VARS[@]}" "''${CMD[@]}")
      fi

      # wrappers (order matters!)
      if [ $USE_MANGOHUD -eq 1 ]; then
        CMD=(${pkgs.mangohud}/bin/mangohud "''${CMD[@]}")
      fi

      if [ $USE_GAMEMODE -eq 1 ]; then
        CMD=(${pkgs.gamemode}/bin/gamemoderun "''${CMD[@]}")
      fi

      # run #
      "''${CMD[@]}"
      exit $?
    '')
  ];
}
