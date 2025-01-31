import os
import subprocess
from libqtile import hook
from libqtile.config import Click, Drag
from libqtile.lazy import lazy

from keys import init_keys
from layouts import init_layouts
from groups import init_groups
from screens import init_screens

@hook.subscribe.startup_once
def start_once():
    os.system("xset -dpms")
    os.system("xset s off")
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])

groups, group_keys= init_groups()
keys = init_keys() + group_keys
layouts = init_layouts()
screens = init_screens()

# Mouse config
mod = "mod4"
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "LG3D"
