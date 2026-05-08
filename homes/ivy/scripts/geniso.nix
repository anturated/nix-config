{
  pkgs,
  config,
  osConfig,
  ...
}:

let
  inherit (config.sops) secrets;
in
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "geniso";

      runtimeInputs = with pkgs; [
        curl
        jq
        libnotify
        coreutils
        gum
      ];

      text = ''
        #!/usr/bin/env bash

        TARGET="''${1:-saeth}" # overrideable derivation
        CDN_URL="https://burger.anturated.dev"
        CDN_PASS=$(cat ${secrets.cdn-pass.path})
        CHAT_ID=$(cat ${secrets.tg-chat.path})
        TG_TOKEN=$(cat ${secrets.tg-token.path})
        total_start=$(date +%s)

        tg_send() {
          curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN/sendMessage" \
            -H "Content-Type: application/json" \
            -d "$(jq -n \
              --arg chat_id "$CHAT_ID" \
              --arg text "$*" \
              '{parse_mode: "HTML", chat_id: $chat_id, text: $text}')" \
          > /dev/null
        }

        format_time() {
          local s=$1
          printf '%02dh %02dm %02ds' \
            $((s/3600)) \
            $(((s%3600)/60)) \
            $((s%60))
        }

        # idk if it'll ever happen but check for empty pass
        if [[ -z "$CDN_PASS" ]]; then
          echo "CDN_PASS is not set" >&2
          exit 1
        fi

        echo "• ──────────────────── GenISO ──────────────────── •"
        build_log=$(mktemp)
        build_start=$(date +%s)
        BUILD_EXIT=0
        gum spin \
          --title "Building iso for $TARGET..." \
          -s minidot \
          --spinner.foreground 2 \
          -- \
        sh -c "nix build '.#nixosConfigurations.$TARGET.config.system.build.isoImage' > $build_log 2>&1" \
        || BUILD_EXIT=$?
        build_end=$(date +%s)

        if [[ $BUILD_EXIT -ne 0 ]]; then
          ERROR=$(tail -50 "$build_log")
          tg_send "<b>⚠️CeiriOS build failed⚠️</b>
            <blockquote expandable>LOGS
              $(echo "$ERROR" | head -30)
            </blockquote>"
          notify-send "ceirios build failed" "check telegram" --icon=dialog-error
          echo "exit: $BUILD_EXIT"
          echo "log: $(cat "$build_log")"
          rm -f "$build_log"
          exit 1
        fi
        rm -f "$build_log"
        echo "  Building iso for $TARGET... Done."

        # find our iso, there's only gonna be one
        ISO_PATH=$(find ./result/iso -type f -name "*.iso" | head -1)
        ISO_NAME=$(basename "$ISO_PATH")
        echo "  Found: $ISO_NAME"

        # if dirty add datetime to make it unique
        DIRTY_TEXT="no" # for telegram
        if [[ "$ISO_NAME" == *"dirty"* ]]; then
          DIRTY_TEXT="yes"
          STAMP=$(date +"%Y%m%d-%H%M%S")
          UPLOAD_NAME="''${ISO_NAME%.iso}-$STAMP.iso"
          echo "! Dirty, will upload this:"
          echo "  $UPLOAD_NAME"
        else
          UPLOAD_NAME="$ISO_NAME"
        fi
        UPLOAD_PATH="/ceirios-builds/$UPLOAD_NAME"

        echo "• ──────────────────── Burger ──────────────────── •"
        # need token
        echo "  Getting tokens..."
        CDN_TOKEN=$(curl -X PUT -s "$CDN_URL/~/api/auth" \
          -F "login=builder" \
          -F "password=$CDN_PASS" | jq -r '.data.token')

        # known to break unfortunately
        if [[ -z "$CDN_TOKEN" || "$CDN_TOKEN" == "null" ]]; then
          echo "!!FAILED" >&2
          exit 1
        fi

        # upload
        ISO_SIZE=$(du -sh "$ISO_PATH" | cut -f1)
        echo "╭╴Uploading $ISO_SIZE of"
        echo "╰─󰁔 $UPLOAD_NAME"
        upload_start=$(date +%s)
        gum spin \
          --title "This'll take a while. Go get some water." \
          -s minidot \
          --spinner.foreground 2 \
          --show-error \
          -- \
        curl -X PUT "$CDN_URL/~/api/file" \
           --header "Authorization: Bearer $CDN_TOKEN" \
           --data-binary "@$ISO_PATH" \
           --url-query "path=$UPLOAD_PATH"
        upload_end=$(date +%s)

        # will exit silently so we do this legendary move
        echo "  ISO uploaded."

        # get permalink just in case
        echo "  Getting permalink..."
        LINK_RESPONSE=$(curl -X GET -s "$CDN_URL/~/api/link" \
          --header "Authorization: Bearer $CDN_TOKEN" \
          --url-query "path=/ceirios-builds/$UPLOAD_NAME")
        URL=$(echo "$LINK_RESPONSE" | jq -r '.data.url')
        total_end=$(date +%s)

        build_time=$((build_end - build_start))
        upload_time=$((upload_end - upload_start))
        total_time=$((total_end - total_start))

        echo "• ──────────────────────────────────────────────── •"
        echo "  Total time: $(format_time "$total_time")"
        echo "  Parrot should get the permalink."
        echo "  Geniso done. Goodbye."
        echo "• ──────────────────────────────────────────────── •"

        # notifications
        notify-send "ceirios iso built" "$URL" --icon=media-optical

        # might as well send a telegram message
        tg_send "
          <b>✅CeiriOS build successfull✅</b>
          <blockquote expandable>$ISO_NAME
              Target: $TARGET
              Took: $(format_time "$total_time")
            • ── Assembly ── •
              Took: $(format_time "$build_time")
              Size: $ISO_SIZE
              Dirty: $DIRTY_TEXT
            • ─── Upload ─── •
              Took: $(format_time "$upload_time")
              Works (good)
            • ──── Host ──── •
              $(whoami)@$(hostname)
              rev: ${osConfig.system.configurationRevision}
            • ────────────── •
          </blockquote>

          <code>$URL</code>
        "
      '';
    })
  ];

  sops.secrets = {
    cdn-pass = { };
    tg-chat = { };
    tg-token = { };
  };
}
