{ pkgs, ... }:

let
  pythonEnv = pkgs.python3.withPackages (
    ps: with ps; [
      dbus-python
      pygobject3
    ]
  );

  kaleDaemon = pkgs.writeTextFile {
    name = "kaled.py";
    destination = "/bin/kaled.py";
    executable = true;
    text = ''
      #!${pythonEnv}/bin/python3
      import dbus
      import dbus.service
      import dbus.mainloop.glib
      from gi.repository import GLib
      import subprocess

      class kaleDaemon(dbus.service.Object):
          def __init__(self):
              bus_name = dbus.service.BusName('com.anturated.kaled', bus=dbus.SystemBus())
              dbus.service.Object.__init__(self, bus_name, '/com/anturated/kaled')
              self.clients = set()
              print("[kale] TLP Daemon started...")

          def update_tlp(self):
              if len(self.clients) > 0:
                  print(f"[kale] Active clients: {len(self.clients)}. Setting TLP to AC.")
                  subprocess.run(["${pkgs.tlp}/bin/tlp", "ac"])
              else:
                  print("[kale] No active clients. Setting TLP to BAT.")
                  subprocess.run(["${pkgs.tlp}/bin/tlp", "bat"])

          @dbus.service.method('com.anturated.kaled', in_signature='i')
          def RegisterClient(self, pid):
              self.clients.add(pid)
              self.update_tlp()
              return f"[kale] Registered {pid}"

          @dbus.service.method('com.anturated.kaled', in_signature='i')
          def UnregisterClient(self, pid):
              if pid in self.clients:
                  self.clients.remove(pid)
              self.update_tlp()
              return f"[kale] Unregistered {pid}"

      dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
      daemon = kaleDaemon()
      loop = GLib.MainLoop()
      loop.run()
    '';
  };
in
{
  # 1. The D-Bus Policy (Allows users to talk to the daemon)
  services.dbus.packages = [
    (pkgs.writeTextFile {
      name = "kaled-dbus-conf";
      destination = "/share/dbus-1/system.d/com.anturated.kaled.conf";
      text = ''
        <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
         "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
        <busconfig>
          <policy user="root">
            <allow own="com.anturated.kaled"/>
          </policy>
          <policy context="default">
            <allow send_destination="com.anturated.kaled"/>
          </policy>
        </busconfig>
      '';
    })
  ];

  # 2. The Background Service
  systemd.services.kaled = {
    description = "Daemon for TLP bs to use with kale";
    after = [ "dbus.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${kaleDaemon}/bin/kaled.py";
      Restart = "always";
    };
  };
}
