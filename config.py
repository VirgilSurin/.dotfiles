# Copyright (c) 2010 Aldo Cortesi Copyright (c) 2010, 2014 dequis Copyright (c) 2012 Randall Ma Copyright (c) 2012-2014 Tycho Andersen Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile import bar, layout, widget, qtile, extension
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration
import themes
import copy

# from libqtile.utils import guess_terminal
from os.path import expanduser

mod = "mod4"
# terminal = guess_terminal()
myBrowser = "chromium"
editor = "emacsclient -c -a 'emacs' "
# terminal = editor + "--eval \"(progn (vterm) (delete-other-windows))\""
terminal = "alacritty"
colors = themes.Gruvbox

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # WINDOW MANAGEMENT
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Move between screens
    Key([mod], "n", lazy.next_screen()),

    # Move windows between left/right columns or move up/down in current stack.
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "k", lazy.layout.grow(), desc="Grow"),
    Key([mod, "control"], "j", lazy.layout.shrink(), desc="Shrink"),
    Key([mod, "control"], "n", lazy.layout.normalize()),
    Key([mod, "control"], "Return", lazy.maximize(), desc="Maximize window"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),

    # lock
    Key([mod, "control", "shift"], "l", lazy.spawn(expanduser("~/.dotfiles/scripts/lock_screen.sh"), shell=True), desc="Lock the screen"),


    # app shortcut
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "b", lazy.spawn(myBrowser), desc="Launch my web browser"),
    Key([mod], "e", lazy.spawn(editor), desc="Launch my editor"),
    Key([mod], "v", lazy.spawn(editor + "--eval '(dired nil)'"), desc="Open file manager"),
    Key([mod, "control"], "s", lazy.spawn("flameshot gui", shell=True), desc="Screenshot"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], 'r', lazy.spawn("rofi -show drun", shell=True)),
    # Sound
    Key([], "xF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer sset Master 5%-"), desc="Lower Volume by 5%"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer sset Master 5%+"), desc="Raise Volume by 5%"),

    # brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),

]


groups = [
    Group("DEV"),
    Group("SYS"),
    Group("WWW"),
    Group("DOC"),
    Group("CHAT"),
    Group("MUS"),
]

group_keys = ["a", "s", "d", "f", "u", "i"]
for i in range(len(groups)):
    group_key = group_keys[i]
    group_name = groups[i].name
    keys.append(Key([mod], group_key, lazy.group[group_name].toscreen()))
    keys.append(Key([mod, "control"], group_key, lazy.window.togroup(group_name, switch_group = False)))
    keys.append(Key([mod, "shift"], group_key, lazy.window.togroup(group_name, switch_group = True)))
# for i in groups:
#     keys.extend(
#         [
#             # mod1 + letter of group = switch to group
#             Key(
#                 [mod],
#                 i.name,
#                 lazy.group[i.name].toscreen(),
#                 desc="Switch to group {}".format(i.name),
#             ),
#             # mod1 + shift + letter of group = switch to & move focused window to group
#             Key(
#                 [mod, "shift"],
#                 i.name,
#                 lazy.window.togroup(i.name, switch_group=True),
#                 desc="Switch to & move focused window to group {}".format(i.name),
#             ),
#             # Or, use below if you prefer not to switch to that group.
#             # # mod1 + shift + letter of group = move focused window to group
#             # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
#             #     desc="move focused window to group {}".format(i.name)),
#         ]
#     )


# LAYOUTS
layout_theme = {"border_width": 3,
                "margin": 10,
                "border_focus": colors["blue"],
                "border_normal": colors["bg"]
                }

layouts = [
    layout.MonadTall(**layout_theme),
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"],
                   # border_width=4,
                   # margin=10,
                   # border_on_single=True
                   # ),
    layout.Max(**layout_theme),
    # layout.Floating(**layout_theme),
    # Try more layouts by unleashing below layouts.

    # layout.Tile(**layout_theme),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]


widget_defaults = dict(
    font = "Ubuntu Bold",
    fontsize = 12,
    padding = 0,
    background = colors["bg"],
)
sep = widget.Sep(linewidth = 0,
                 padding = 6,
                 foreground = colors["fg"],
                 background = colors["bg"])
sep_bar = widget.TextBox(
                    text = '|',
                    background = colors["bg"],
                    foreground = colors["fg"],
                    padding = 2,
                    fontsize = 14
                )
extension_defaults = widget_defaults.copy()
def create_widget():
    return [
        sep,
        widget.GroupBox(
            fontsize = 11,
            margin_x = 5,
            margin_y = 5,
            padding_y = 0,
            padding_x = 2,
            borderwidht = 3,
            font = "JetBrains Mono SemiBold",
            active = colors["blue"],
            inactive = colors["fg"],
            rounded = False,
            highlight_method = "line",
            highlight_color = [colors["bg"], colors["bg"]], # if using "line" as  highlight method
            this_current_screen_border = colors["green"],
            other_screen_border = colors["magenta"],

            this_screen_border = colors["green"],
            other_current_screen_border = colors["magenta"],
            foreground = colors["fg"],
            background = [colors["bg"]],
        ),
        sep_bar,
        # widget.TextBox(
        #     text = '  ',
        #     background = colors["bg"] + "60",
        #     foreground = colors["bg"] + "60",
        #     padding = -7,
        #     fontsize = 40
        # ),
        widget.CurrentLayoutIcon(
            foreground = colors["fg"],
            background = colors["bg"],
            padding = 2,
            scale = 0.7,
            use_mask = True,
        ),
        widget.CurrentLayout(
            foreground = colors["fg"],
            background = colors["bg"],
            font = "JetBrains Mono SemiBold",
            padding = 10,
            fontsize = 11,
        ),
        sep_bar,
        widget.WindowName(
            fontsize = 12,
            padding = 5,
            max_chars = 40,
            font = "JetBrains Mono SemiBold",
            foreground = colors["fg"],
            background = colors["bg"],
        ),
        # widget.TextBox(
        #     text = '',
        #     # text = '',
        #     background = colors["bg"] + "60",
        #     foreground = colors["cyan"],
        #     padding = -1,
        #     fontsize = 40
        # ),
        widget.Spacer(length = 8),
        widget.WiFiIcon(
            interface = "wlp6s0",
            # font = "JetBrains Mono SemiBold",
            # fontsize = 11,
            padding = 5,
            foreground = colors["red"],
            wifi_shape = "arc",
            wifi_rectangle_width = 10,
            active_colour = colors["red"],
            disconnected_colour = colors["black"],
            decorations = [
                BorderDecoration(
                    colour = colors["red"],
                    border_width = [0, 0, 2, 0],
                )
            ]
            ),
        widget.Net(
            interface = "wlp6s0",
            format = "{up:^3.0f}{up_suffix} ↑↓ {down:^3.0f}{down_suffix}",
            foreground = colors["red"],
            background = colors["bg"],
            font = "JetBrains Mono SemiBold",
            fontsize = 12,
            padding = 4,
            decorations = [
                BorderDecoration(
                    colour = colors["red"],
                    border_width = [0, 0, 2, 0],
                )
            ]
        ),
        widget.Spacer(length = 8),
        widget.UPowerWidget(
            foreground = colors["green"],
            background = colors["bg"],
            fontsize = 11,
            fill_charge = colors["green"],
            fill_critical = colors["red"],
            fill_low = colors["orange"],
            fill_normal = colors["green"],
            border_colour = colors["green"],
            border_charge_colour = colors["green"],
            border_critical_colour = colors["green"],
            decorations = [
                BorderDecoration(
                    colour = colors["green"],
                    border_width = [0, 0, 2, 0],
                )
            ]
        ),
        widget.Battery(
            foreground = colors["green"],
            background = colors["bg"],
            padding = 2,
            fontsize = 12,
            font = "JetBrains Mono SemiBold",
            format = "{percent:2.0%} ({hour:d}h{min:02d})",
            decorations = [
                BorderDecoration(
                    colour = colors["green"],
                    border_width = [0, 0, 2, 0],
                )
            ]
        ),
        widget.Spacer(length = 8),
        widget.Volume(
            foreground = colors["magenta"],
            background = colors["bg"],
            fontsize = 14,
            font = "JetBrains Mono SemiBold",
            fmt = ' Vol: {} ',
            padding = 10,
            decorations = [
                BorderDecoration(
                    colour = colors["magenta"],
                    border_width = [0, 0, 2, 0],
                )
            ]
            ),
        widget.Spacer(length = 8),
        # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
        # widget.StatusNotifier(),
        widget.Clock(
            fontsize = 12,
            foreground = colors["blue"],
            background = colors["bg"],
            font = "JetBrains Mono SemiBold",
            format = "⏱ %a, %d %b - %H:%M ",
            padding = 10,
            decorations = [
                BorderDecoration(
                    colour = colors["blue"],
                    border_width = [0, 0, 2, 0],
                )
            ]
        ),
        widget.Spacer(length = 8),
        widget.Systray(
            padding = 3,
            background = colors["bg"],
            foreground = colors["blue"],
                       ),
        widget.Spacer(length = 8),
    ]

# wall = "~/.dotfiles/wallpapers/star-wars-naboo-wallpapers.png"
# wall = "~/.dotfiles/wallpapers/mountain-and-river-wallpapers.jpg"
# wall = "~/.dotfiles/wallpapers/mountains-and-river-4k-wallpapers.jpg"
# wall = "~/.dotfiles/wallpapers/nature4.jpg"
# wall = "~/.dotfiles/wallpapers/evergreentrees2.jpg"
wall = "~/.dotfiles/wallpapers/ign_astronaut.png"
screens = [
    Screen(
        wallpaper=wall,
        wallpaper_mode="fill",
        top=bar.Bar(
            create_widget(),
            28,
            border_width=[0, 0, 0, 0],  # Draw top and bottom borders
            border_color=[colors["bg"]] * 4,  # Borders are magenta
            margin = 0,
            background = colors["bg"]
        ),
    ),
    Screen(
        wallpaper = wall,
        wallpaper_mode="fill",
        top=bar.Bar(
            create_widget()[:-2],
            28,
            border_width=[0, 0, 0, 0],  # Draw top and bottom borders
            border_color=[colors["bg"]] * 4,  # Borders are magenta
            margin = 0,
            background = colors["bg"]
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
