{ pkgsStable, ... }:

{
  ceirios.packages = {
    # NOTE: using stable here because openldap won't pass tests
    inherit (pkgsStable) bottles;
  };
}
