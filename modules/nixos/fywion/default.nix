# keep this dir for my own stuff,
# use nixos/services for system stuff
{ ... }:

{
  imports = [
    ./hello-http.nix
    ./mailserver.nix
    ./nginx.nix
    ./obsidian-livesync.nix
    ./website.nix
  ];
}
