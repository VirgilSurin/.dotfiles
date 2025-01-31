from libqtile.config import Key
from libqtile.lazy import lazy
from os.path import expanduser

mod = "mod4"
terminal = "alacritty"
browser = "firefox"
editor = "emacsclient -c -a 'emacs'"

# Direction keys for Workman layout
directions = {
    'left': 'n',
    'right': 'i',
    'up': 'o',
    'down': 'e'
}

@lazy.function
def maximize_by_switching_layout(qtile):
    current_layout_name = qtile.current_group.layout.name
    if current_layout_name == 'monadtall':
        qtile.current_group.layout = 'max'
    elif current_layout_name == 'max':
        qtile.current_group.layout = 'monadtall'

def init_keys():
    keys = [
        # Basic window controls using direction mapping
        *[
            Key(
                [mod],
                directions[direction],
                getattr(lazy.layout, direction)(),
                desc=f"Move focus {direction}",
            )
            for direction in directions
        ],
        *[
            Key(
                [mod, "shift"],
                directions[direction],
                getattr(lazy.layout, f"shuffle_{direction}")(),
                desc=f"Move window {direction}",
            )
            for direction in directions
        ],
        *[
            Key(
                [mod, "control"],
                directions[direction],
                getattr(lazy.layout, f"grow_{direction}")(),
                desc=f"Grow window {direction}",
            )
            for direction in directions
        ],
        # Window management
        # Key([mod], "space", maximize_by_switching_layout(), lazy.window.toggle_fullscreen()),
        Key([mod, "space"], "Return", lazy.maximize()),
        Key([mod], "t", lazy.window.toggle_floating()),
        # Layout controls
        Key(
            [mod],
            "equal",
            lazy.layout.grow_left().when(layout=["bsp", "columns"]),
            lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        ),
        Key(
            [mod],
            "minus",
            lazy.layout.grow_right().when(layout=["bsp", "columns"]),
            lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        ),
        Key([mod, "shift"], "Return", lazy.layout.toggle_split()),
        Key([mod], "Tab", lazy.next_layout()),
        # Screen management
        Key([mod], "y", lazy.next_screen()),
        Key([mod, "shift"], "y", lazy.prev_screen()),
        # System controls
        Key(
            [mod, "control", "shift"],
            "l",
            lazy.spawn(expanduser("~/.dotfiles/scripts/lock_screen.sh"), shell=True),
        ),
        Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
        Key([], "XF86AudioLowerVolume", lazy.spawn("amixer sset Master 5%-")),
        Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer sset Master 5%+")),
        Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
        Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),

        # Applications
        Key([mod], "r", lazy.spawn("rofi -show drun"), desc="Launch apps"),
        Key([mod, "shift"], "r", lazy.spawn("rofi -show run"), desc="Run commands"),
        Key(
            [mod, "shift"],
            "m",
            lazy.spawn("monitor-switch"),
            desc="Change monitor config",
        ),
        Key(
            [mod, "control"],
            "m",
            lazy.spawn("rofi -show calc -modi calc -no-show-match -no-sort"),
            desc="Launch calculator",
        ),
        Key([mod], "Return", lazy.spawn("alacritty"), desc="Launch terminal"),
        Key([mod], "b", lazy.spawn(browser), desc="Launch browser"),
        Key([mod], "x", lazy.spawn(editor), desc="Emacs Dashboard"),
        Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
        Key([mod], "m", lazy.spawn("dolphin"), desc="Open file manager"),
        Key([], "Print", lazy.spawn("flameshot gui")),
        # Qtile controls
        Key([mod], "q", lazy.window.kill()),
        Key([mod, "control"], "r", lazy.reload_config()),
        Key([mod, "control"], "q", lazy.shutdown()),
    ]
    return keys
