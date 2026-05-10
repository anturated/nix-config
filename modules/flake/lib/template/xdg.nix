# You can generate something like this using xdg-ninja
let
  XDG_CONFIG_HOME = "$HOME/.config";
  XDG_CACHE_HOME = "$HOME/.cache";
  XDG_DATA_HOME = "$HOME/.local/share";
  XDG_STATE_HOME = "$HOME/.local/state";
  XDG_BIN_HOME = "$HOME/.local/bin";
  XDG_RUNTIME_DIR = "/run/user/$UID";
in
{
  simple = {
    dataHome = XDG_DATA_HOME;
    configHome = XDG_CONFIG_HOME;
    cacheHome = XDG_CACHE_HOME;
  };

  # global env
  global = {
    inherit
      XDG_CONFIG_HOME
      XDG_CACHE_HOME
      XDG_DATA_HOME
      XDG_STATE_HOME
      XDG_BIN_HOME
      XDG_RUNTIME_DIR
      ;
    PATH = [ "$bin" ];
  };

  user =
    xdg:
    let
      data = xdg.dataHome;
      config = xdg.configHome;
      cache = xdg.cacheHome;
    in
    {
      # desktop
      KDEHOME = "${config}/kde";
      XCOMPOSECACHE = "${cache}/X11/xcompose";
      ERRFILE = "${cache}/X11/xsession-errors";
      WINEPREFIX = "${data}/wine";

      # programs
      GNUPGHOME = "${data}/gnupg";
      LESSHISTFILE = "${data}/less/history";
      CUDA_CACHE_PATH = "${cache}/nv";
      STEPPATH = "${data}/step";
      WAKATIME_HOME = "${config}/wakatime";
      INPUTRC = "${config}/readline/inputrc";
      PLATFORMIO_CORE_DIR = "${data}/platformio";
      DOTNET_CLI_HOME = "${data}/dotnet";
      MPLAYER_HOME = "${config}/mplayer";
      SQLITE_HISTORY = "${cache}/sqlite_history";

      # programming
      ANDROID_HOME = "${data}/android";
      ANDROID_USER_HOME = "${data}/android";
      GRADLE_USER_HOME = "${data}/gradle";
      IPYTHONDIR = "${config}/ipython";
      JUPYTER_CONFIG_DIR = "${config}/jupyter";
      GOPATH = "${data}/go";
      M2_HOME = "${data}/m2";
      CARGO_HOME = "${data}/cargo";
      RUSTUP_HOME = "${data}/rustup";
      STACK_ROOT = "${data}/stack";
      STACK_XDG = 1;
      NODE_REPL_HISTORY = "${data}/node_repl_history";
      NPM_CONFIG_CACHE = "${cache}/npm";
      NPM_CONFIG_TMP = "${XDG_RUNTIME_DIR}/npm";
      NPM_CONFIG_USERCONFIG = "${config}/npm/config";
    };
}
