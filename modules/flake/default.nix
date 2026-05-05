{ inputs }:

let
  inherit (inputs) nixpkgs self;
  inherit (nixpkgs) lib;

  # auto-discover from machines/
  machineNames = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir (self + "/machines"))
  );

  discovered = lib.genAttrs machineNames (_: { });

  mkHosts = lib.mapAttrs self.lib.mkHost;
in
{
  lib = import ./lib { inherit lib inputs; };

  nixosConfigurations = mkHosts discovered // {
    # manual overrides go here
    # adamantite = {
    #   class = "iso";
    # };
  };
}
