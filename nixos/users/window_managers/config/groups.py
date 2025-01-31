from libqtile.config import Group, Key
from libqtile.lazy import lazy

mod = "mod4"
def init_groups():
    groups = [
        Group(name="a", label=" "),
        Group(name="s", label="󰖟"),
        Group(name="h", label="󰈙"),
        Group(name="t", label=""),
        Group(
            name="f", label="󰍦", matches=[Match(wm_class="signal")], layout="columns"
        ),
        Group(
            name="u", label="󰓇", matches=[Match(wm_class="spotify")], layout="columns"
        ),
    ]
    keys = []
    for i in groups:
        keys.extend(
            [
                # mod1 + letter of group = switch to group
                Key(
                    [mod],
                    i.name,
                    lazy.group[i.name].toscreen(),
                    desc="Switch to group {}".format(i.name),
                ),
                # mod1 + shift + letter of group = switch to & move focused window to group
                Key(
                    [mod, "shift"],
                    i.name,
                    lazy.window.togroup(i.name, switch_group=True),
                    desc="Switch to & move focused window to group {}".format(i.name),
                ),
                Key(
                    [mod, "control"],
                    i.name,
                    lazy.window.togroup(i.name),
                    desc="Switch focused window to group {}".format(i.name),
                ),
            ]
        )

    return groups, keys
