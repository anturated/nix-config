{ ... }:

{
  programs.vesktop = {
    enable = true;

    settings = {
      # disable auto update because it breaks vencord sometimes i guess
      autoUpdate = false;
      autoUpdateNotification = false;

      notifyAboutUpdates = false;
      useQuickCss = true;
      disableMinSize = true;
      minimizeToTray = false;
    };

    vencord.settings = {
      # load matugen theme
      enabledThemes = [ "matugen.css" ];
      plugins = {
        AlwaysExpandRoles.enabled = true;
        BetterGifPicker.enabled = true;
        BetterRoleContext.enabled = true;
        BetterSessions.enabled = true;
        CallTimer.enabled = true;
        ClearURLs.enabled = true;
        ConsoleShortcuts.enabled = true;
        CrashHandler.enabled = true;
        Experiments.enabled = true;
        ExpressionCloner.enabled = true;
        FakeNitro.enabled = true;
        FixImagesQuality.enabled = true;
        FriendsSince.enabled = true;
        ImageZoom.enabled = true;
        ImplicitRelationships.enabled = true;
        NewGuildSettings.enabled = true;
        NoReplyMention.enabled = true;
        PermissionFreeWill.enabled = true;
        PermissionViewer.enabled = true;
        PictureInPicture.enabled = true;
        RevealAllSpoilers.enabled = true;
        ServerInfo.enabled = true;
        VolumeBooster={
          enabled = true;
          multiplier = 4;
        };
        WebKeyBinds.enabled = true;
        WebScreenShareFixes.enabled = true;
      };
    };
  };
}
