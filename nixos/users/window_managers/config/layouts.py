from libqtile import layout
from themes import One as colors

mod = "mod4"
layout_theme = {
    "border_width": 3,
    "margin": 0,
    "border_focus": colors["blue"],
    "border_normal": colors["black"]
}

def init_layouts():
    return [
        layout.Columns(
            **layout_theme,
            border_on_single=True,
            border_focus_stack=colors["magenta"],
            border_normal_stack=colors["bg"]
        ),
        # layout.MonadTall(
        #     **layout_theme,
        #     ratio=0.6,
        # ),
        layout.Max(**layout_theme),
    ]

# groups.py
from libqtile.config import Group, Key
from libqtile.lazy import lazy

def init_groups():
    groups = [
        Group("DEV"),
        Group("WEB"),
        Group("DOC"),
        Group("SYS"),
        Group("MSG"),
        Group("MUS"),
    ]

    group_keys = ["a", "s", "d", "f", "u", "i"]
    keys = []

    for i, key in enumerate(group_keys):
        group_name = groups[i].name
        keys.extend([
            Key([mod], key, lazy.group[group_name].toscreen()),
            Key([mod, "control"], key,
                lazy.window.togroup(group_name, switch_group=False)),
            Key([mod, "shift"], key,
                lazy.window.togroup(group_name, switch_group=True)),
        ])

    return groups
