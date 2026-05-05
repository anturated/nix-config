import dbus
import dbus.service
import dbus.mainloop.glib
from gi.repository import GLib
from pathlib import Path

class kaleDaemon(dbus.service.Object):
    def __init__(self):
        bus_name = dbus.service.BusName('com.anturated.kaled', bus=dbus.SystemBus())
        dbus.service.Object.__init__(self, bus_name, '/com/anturated/kaled')
        self.clients = set()
        print("Kale Daemon started...")

    def update_performance(self):
        isGaming = len(self.clients) > 0

        governor   = "performance" if isGaming else "schedutil"
        boost      = "1"           if isGaming else "0"
        profile    = "performance" if isGaming else "balanced"

        if isGaming:
            print(f"[kale] Active clients: {len(self.clients)}. We are gaming.")
        else:
            print("[kale] No active clients. We are not gaming.")

        for path in Path("/sys/devices/system/cpu").glob("cpu*/cpufreq/scaling_governor"):
            path.write_text(governor)

        Path("/sys/devices/system/cpu/cpufreq/boost").write_text(boost)
        Path("/sys/firmware/acpi/platform_profile").write_text(profile)

    @dbus.service.method('com.anturated.kaled', in_signature='i')
    def RegisterClient(self, pid):
        self.clients.add(pid)
        self.update_performance()
        return f"[kale] Registered {pid}"

    @dbus.service.method('com.anturated.kaled', in_signature='i')
    def UnregisterClient(self, pid):
        if pid in self.clients:
            self.clients.remove(pid)
        self.update_performance()
        return f"[kale] Unregistered {pid}"

dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
daemon = kaleDaemon()
loop = GLib.MainLoop()
loop.run()
