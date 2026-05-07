{ osConfig, ... }:

{
  config = {
    ceirios.profiles = {
      inherit (osConfig.ceirios.profiles)
        graphical
        headless
        workstation
        laptop
        server
        gaming
        ;
    };
  };
}
