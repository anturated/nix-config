{
  pkgs,
  host,
  osConfig,
  ...
}:

let
  flakeDir = osConfig.ceirios.system.flakeDir;
in
{

  config.home.packages = [
    (pkgs.writeShellScriptBin "rebuild" ''
      #!/usr/bin/env bash
      set -e

      REPO="https://github.com/anturated/nix-config.git"

      usage() {
        echo "Usage:"
        echo "  rebuild           -> local flake (requires config.ceirios.system.flakeDir)"
        echo "  rebuild -m        -> from GitHub master"
        echo "  rebuild -s        -> latest tag (stable)"
        echo "  rebuild <tag>     -> specific tag (e.g. 1.0.0)"
        exit 1
      }

      get_latest_tag() {
        git ls-remote --tags --refs "$REPO" \
          | awk -F/ '{print $3}' \
          | sort -V \
          | tail -n1
      }

      if [[ $# -eq 0 ]]; then
        if [[ "${flakeDir}" == "" ]]; then
          usage
        fi
        echo " Rebuilding from local..."
        sudo nixos-rebuild switch --flake "${flakeDir}#${host}"

      elif [[ "$1" == "-m" ]]; then
        echo " Rebuilding from master..."
        sudo nixos-rebuild switch --flake "github:anturated/nix-config#${host}" --refresh

      elif [[ "$1" == "-s" || "$1" == "--stable" ]]; then
        echo " Fetching latest tag..."
        TAG="$(get_latest_tag)"

        if [[ -z "$TAG" ]]; then
          echo "[!!] Failed to determine latest tag"
          exit 1
        fi

        echo " Rebuilding from latest tag: [$TAG]..."
        sudo nixos-rebuild switch --flake "github:anturated/nix-config/$TAG#${host}" --refresh

      elif [[ $# -eq 1 ]]; then
        TAG="$1"
        echo " Rebuilding from tag: [$TAG]..."
        sudo nixos-rebuild switch --flake "github:anturated/nix-config/$TAG#${host}" --refresh

      else
        usage
      fi
    '')
  ];
}
