{ osConfig, ... }:

{
  config = {
    garden.profiles = {
      inherit (osConfig.garden.profiles)
        graphical
        headless
        workstation
        laptop
        server
        gaming
        coding
        ;
    };
  };
}
