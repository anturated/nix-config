{ pkgs, config, ... }:

let
  inherit (config.sops) secrets;
in
{
  environment.systemPackages = [
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

        # idk if it'll ever happen but check for empty pass
        if [[ -z "$CDN_PASS" ]]; then
          echo "CDN_PASS is not set" >&2
          exit 1
        fi

        echo "• ──────────────────── genISO ──────────────────── •"
        echo "  Kids am i right"
        echo "  Building iso for $TARGET..."
        echo " ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ── "
        nix build ".#nixosConfigurations.$TARGET.config.system.build.isoImage"
        echo "                       Success" # nix build exits with no output
        echo " ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ── "

        # find our iso, there's only gonna be one
        ISO_PATH=$(find ./result/iso -type f -name "*.iso" | head -1)
        ISO_NAME=$(basename "$ISO_PATH")
        echo "  Found: $ISO_NAME"

        # if dirty add datetime to make it unique
        if [[ "$ISO_NAME" == *"dirty"* ]]; then
          STAMP=$(date +"%Y%m%d-%H%M%S")
          UPLOAD_NAME="''${ISO_NAME%.iso}-$STAMP.iso"
          echo "! Dirty, will upload this:"
          echo "  $UPLOAD_NAME"
        else
          UPLOAD_NAME="$ISO_NAME"
        fi

        echo "• ──────────────────── Burger ──────────────────── •"
        # need token
        echo "  Getting tokens..."
        TOKEN=$(curl -X PUT -s "$CDN_URL/~/api/auth" \
          -F "login=builder" \
          -F "password=$CDN_PASS" | jq -r '.data.token')

        # known to break unfortunately
        if [[ -z "$TOKEN" || "$TOKEN" == "null" ]]; then
          echo "!!FAILED" >&2
          exit 1
        fi

        # upload
        echo "╭╴Uploading $(du -sh "$ISO_PATH" | cut -f1) of"
        echo "╰─󰁔 $UPLOAD_NAME"
        gum spin \
          --title "This'll take a while. Go get some water." \
          -s minidot \
          --spinner.foreground 2 \
          --show-error \
          -- \
        curl -X PUT "$CDN_URL/~/api/file" \
           --header "Authorization: Bearer $TOKEN" \
           --data-binary "@$ISO_PATH" \
           --url-query "path=/ceirios-builds/$UPLOAD_NAME"

        # will exit silently so we do this legendary move
        echo "  Done."

        # get permalink just in case
        echo "  Getting permalink..."
        LINK_RESPONSE=$(curl -X GET -s "$CDN_URL/~/api/link" \
          --header "Authorization: Bearer $TOKEN" \
          --url-query "path=/ceirios-builds/$UPLOAD_NAME")
        URL=$(echo "$LINK_RESPONSE" | jq -r '.data.url')

        echo ""
        echo "$URL"
        echo "• ──────────────────────────────────────────────── •"

        notify-send "ceirios iso built" "$URL" --icon=media-optical
      '';
    })
  ];

  sops.secrets = {
    cdn-pass = { };
  };
}
