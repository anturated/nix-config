{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "chwal" ''
      #!/usr/bin/env bash

      WALLPAPER_DIR="$HOME/Pictures/Wallpapers/"
      SCHEME="scheme-tonal-spot"
      # SCHEME="scheme-rainbow"
      # SCHEME="scheme-content"

      thumb_dir="$HOME/.cache/wallthumbs"
      mkdir -p "$thumb_dir"

      img="$WALLPAPER_DIR$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" \) \
          | while read -r file; do
              base=$(basename "$file")
              thumb="$thumb_dir/$base"
              if [ ! -f "$thumb" ]; then
                  printf "%s\0icon\x1fthumbnail://%s\n" "$base" "$file"
                  magick "$file" -thumbnail 200x200 "$thumb" &
              else
                  printf "%s\0icon\x1f%s\n" "$base" "$thumb"
              fi
            done |
            rofi -dmenu \
                 -theme wallpaper 
          )"

      [ -z "$img" ] && exit 0

      # Get focused monitor info
      monitor_json=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)')

      monitor=$(echo "$monitor_json" | jq -r '.name')
      x=$(echo "$monitor_json" | jq -r '.x')
      y=$(echo "$monitor_json" | jq -r '.y')

      # Fallback
      if [ -z "$monitor" ]; then
          monitor_json=$(hyprctl monitors -j | jq -r '.[0]')
          monitor=$(echo "$monitor_json" | jq -r '.name')
          x=$(echo "$monitor_json" | jq -r '.x')
          y=$(echo "$monitor_json" | jq -r '.y')
      fi

      # Set wallpaper only on that monitor
      awww img "$img"\
          --outputs "$monitor"\
          --transition-type any\
          --transition-fps 120\
          --transition-duration 1 &

      # If monitor is at (0,0), run matugen
      if [ "$x" -eq 0 ] && [ "$y" -eq 0 ]; then
          # lots of matugen bs
          hash=$(sha1sum "$img" | cut -d' ' -f1)
          cache="$HOME/.cache/matugen/$SCHEME-$hash.json"

          if [ -f "$cache" ]; then
              echo "cache exists, applying"
              matugen json "$cache"
          else
              echo "cache does not exist, applying from image"
              matugen image -t "$SCHEME" "$img"

              echo "cache generating"
              hex=$(mktemp)
              rgb=$(mktemp)
              rgba=$(mktemp)
              hsl=$(mktemp)
              strip=$(mktemp)

      		echo "generating colors (hex)..."
              matugen image "$img" --dry-run -t "$SCHEME" -j hex > "$hex"
      		echo "generating colors (rgb)..."
              matugen image "$img" --dry-run -t "$SCHEME" -j rgb > "$rgb"
      		echo "generating colors (rgba)..."
              matugen image "$img" --dry-run -t "$SCHEME" -j rgba > "$rgba"
      		echo "generating colors (hsl)..."
              matugen image "$img" --dry-run -t "$SCHEME" -j hsl > "$hsl"
      		echo "generating colors (strip)..."
              matugen image "$img" --dry-run -t "$SCHEME" -j strip > "$strip"

              echo "merging..."

              jq -n \
                  --argjson hex "$(cat "$hex")" \
                  --argjson rgb "$(cat "$rgb")" \
                  --argjson rgba "$(cat "$rgba")" \
                  --argjson hsl "$(cat "$hsl")" \
                  --argjson strip "$(cat "$strip")" \
              '{
              colors:
                  ($hex.colors | to_entries | map(
                  . as $outer |
                  {
                      key: $outer.key,
                      value: (
                      $outer.value | to_entries | map(
                          . as $inner |
                          {
                          key: $inner.key,
                          value: {
                              hex: $hex.colors[$outer.key][$inner.key],
                              rgb: $rgb.colors[$outer.key][$inner.key],
                              rgba: $rgba.colors[$outer.key][$inner.key],
                              hsl: $hsl.colors[$outer.key][$inner.key],
                              hex_stripped: $strip.colors[$outer.key][$inner.key]
                          }
                          }
                      ) | from_entries
                      )
                  }
                  ) | from_entries)
              }
              ' > "$cache"
          fi
      fi
    '')
  ];
}
