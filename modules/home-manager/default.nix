{ config, inputs, self, lib, pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = { inherit inputs self; };

    users = lib.mapAttrs (username: _: {
      imports = [
        (self + "/homes/${username}/default.nix")
        (self + "/modules/home-manager/default.nix")
      ];
    }) config.ceirios.users;
  };

  # lets you run `home-manager switch` manually on the machine too
  environment.systemPackages = [ pkgs.home-manager ];
}
