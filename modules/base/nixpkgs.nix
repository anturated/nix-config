{ ... }:

{
  nixpkgs.config = {
    # enable spyware
    nixpkgs.config.allowUnfree = true;
  };
}
