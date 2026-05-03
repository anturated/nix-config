{ inputs }:

let
  inherit (inputs) nixpkgs self;
  inherit (nixpkgs) lib;

  mkHost = self.lib.mkHost;

  # auto-discover from machines/
  machineNames = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir (self + "/machines"))
  );
in
{
  # generate configuration for given machine
  nixosConfigurations = lib.genAttrs machineNames (name: mkHost { inherit name inputs; });
}
