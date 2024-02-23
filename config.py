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
# from qtile_extras import widget
# from qtile_extras.widget.decorations import BorderDecoration
import themes
import copy

# from libqtile.utils import guess_terminal
from os.path import expanduser

mod = "mod4"
# terminal = guess_terminal()
myBrowser = "chromium"
editor = "emacsclient -c -a 'alacritty vi' "
# terminal = editor + "--eval \"(progn (vterm) (delete-other-windows))\""
terminal = "alacritty"
colors = themes.Everforest


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
    Key([mod], "v", lazy.spawn("ranger", shell=True), desc="Open file manager"),
    Key([mod, "control"], "s", lazy.spawn("flameshot gui", shell=True), desc="Screenshot"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
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
    Group("WWW"),
    Group("DOC"),
    Group("CHAT"),
    Group("MUS"),
    Group("SYS")
]

group_keys = ["a", "s", "d", "f", "u", "i", "o", "p"]
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
layout_theme = {"border_width": 5,
                "margin": 10,
                "border_focus": colors["magenta"],
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
    # Try more layouts by unleashing below layouts.

    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]


widget_defaults = dict(
    fontsize = 10,
    padding = 2,
    background = colors["bg"],
    foreground = colors["fg"]
)
sep = widget.Sep(linewidth = 0,
                 padding = 6,
                 foreground = colors["fg"],
                 background = colors["bg"] + "A0")
sep_bar = widget.TextBox(
                    text = '|',
                    background = colors["bg"],
                    foreground = colors["black"],
                    padding = 2,
                    fontsize = 26
                )
extension_defaults = widget_defaults.copy()
widget_list = [
    sep,
    widget.GroupBox(
        fontsize = 11,
        padding_y = 4,
        padding_x = 4,
        borderwidht = 1,
        font = "JetBrains Mono SemiBold",
        active = colors["green"] + "FF",
        inactive = colors["fg"] + "FF",
        rounded = True,
        highlight_method = "line",
        highlight_color = [colors["bg"] + "00", colors["bg"] + "00"], # if using "line" as  highlight method
        this_current_screen_border = colors["green"],
        other_screen_border = colors["red"],

        this_screen_border = colors["fg"],
        other_current_screen_border = colors["bg"],
        foreground = colors["fg"] + "FF",
        background = [colors["bg"] + "A0"],
    ),
    widget.TextBox(
        text = '  ',
        background = colors["bg"] + "60",
        foreground = colors["bg"] + "60",
        padding = -7,
        fontsize = 40
    ),
    widget.WindowTabs(
        fontsize = 12,
        padding = 5,
        max_chars = 40,
        font = "JetBrains Mono SemiBold",
        foreground = colors["black"],
        background = colors["bg"] + "60"
    ),
    widget.TextBox(
        text = '',
        # text = '',
        background = colors["bg"] + "60",
        foreground = colors["cyan"],
        padding = -1,
        fontsize = 40
    ),
    widget.CurrentLayout(
        foreground = colors["black"],
        background = colors["cyan"],
        font = "JetBrains Mono SemiBold",
        padding = 10,
        fontsize = 12,
    ),
    widget.TextBox(
        # text = '',
        text = '',
        background = colors["cyan"],
        foreground = colors["red"],
        padding = -1,
        fontsize = 40
    ),
    # widget.Wlan(
    #     disconnected_message = "󰖪 Disconnected",
    #     interface = "wlp6s0", # use "nmcli device status" to know what the write here
    #     foreground = colors[3],
    #     background = colors[0],
    #     fontsize = 12,
    #     padding = 5
    # ),
    widget.Net(
        interface = "wlp6s0",
        format = "  {up:^3.0f}{up_suffix} ↑↓ {down:^3.0f}{down_suffix}",
        foreground = colors["black"],
        background = colors["red"],
        font = "JetBrains Mono SemiBold",
        fontsize = 12,
        padding = 10
    ),
    # widget.WiFiIcon(
    #     foreground = colors[1],
    #     background = colors[3],
    #     fontsize = 12,
    #     padding = 10
    # ),
    widget.TextBox(
        # text = '',
        text = '',
        background = colors["red"],
        foreground = colors["green"],
        padding = -1,
        fontsize = 40
    ),
    # widget.UPowerWidget(
    #     foreground = colors["black"],
    #     background = colors["green"],
    #     fontsize = 12
    # ),
    widget.Battery(
        foreground = colors["black"],
        background = colors["green"],
        padding = 10,
        fontsize = 12,
        font = "JetBrains Mono SemiBold",
        format = "  {percent:2.0%} ({hour:d}h{min:02d})"
    ),
    widget.TextBox(
        # text = '',
        text = '',
        background = colors["green"],
        foreground = colors["magenta"],
        padding = -1,
        fontsize = 40
    ),
    widget.Volume(
        foreground = colors["black"],
        background = colors["magenta"],
        fontsize = 16,
        font = "JetBrains Mono SemiBold",
        fmt = ' : {} ',
        padding = 10,
        emoji = False,
        emoji_list = ['󰝟', '󰕿', '󰖀', '󰕾']
        ),
    # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
    # widget.StatusNotifier(),
    widget.TextBox(
        # text = '',
        text = '',
        background = colors["magenta"],
        foreground = colors["blue"],
        padding = -1,
        fontsize = 40
    ),
    widget.Systray(
        background = colors["blue"]
    ),
    widget.Clock(
        fontsize = 12,
        foreground = colors["black"],
        background = colors["blue"],
        font = "JetBrains Mono SemiBold",
        format = "%A, %d %B - %H:%M ",
        padding = 10
    ),
]
widget_list_second = [
    sep,
    widget.GroupBox(
        fontsize = 11,
        padding_y = 4,
        padding_x = 4,
        borderwidht = 1,
        font = "JetBrains Mono SemiBold",
        active = colors["green"] + "FF",
        inactive = colors["fg"] + "FF",
        rounded = True,
        highlight_method = "line",
        this_current_screen_border = colors["green"],
        other_screen_border = colors["blue"],

        this_screen_border = colors["fg"],
        other_current_screen_border = colors["bg"],
        foreground = colors["fg"] + "FF",
        background = [colors["bg"] + "A0"],
    ),
    widget.TextBox(
        text = '  ',
        background = colors["bg"] + "60",
        foreground = colors["bg"] + "60",
        padding = -7,
        fontsize = 40
    ),
    widget.WindowTabs(
        fontsize = 12,
        padding = 5,
        max_chars = 40,
        font = "JetBrains Mono SemiBold",
        foreground = colors["black"],
        background = colors["bg"] + "60"
    ),
    widget.TextBox(
        text = '',
        # text = '',
        background = colors["bg"] + "60",
        foreground = colors["cyan"],
        padding = -1,
        fontsize = 40
    ),
    widget.CurrentLayout(
        foreground = colors["black"],
        background = colors["cyan"],
        font = "JetBrains Mono SemiBold",
        padding = 10,
        fontsize = 12,
    ),
    widget.TextBox(
        # text = '',
        text = '',
        background = colors["cyan"],
        foreground = colors["red"],
        padding = -1,
        fontsize = 40
    ),
    # widget.Wlan(
    #     disconnected_message = "󰖪 Disconnected",
    #     interface = "wlp6s0", # use "nmcli device status" to know what the write here
    #     foreground = colors[3],
    #     background = colors[0],
    #     fontsize = 12,
    #     padding = 5
    # ),
    widget.Net(
        interface = "wlp6s0",
        format = "  {up:^3.0f}{up_suffix} ↑↓ {down:^3.0f}{down_suffix}",
        foreground = colors["black"],
        background = colors["red"],
        font = "JetBrains Mono SemiBold",
        fontsize = 12,
        padding = 10
    ),
    # widget.WiFiIcon(
    #     foreground = colors[1],
    #     background = colors[3],
    #     fontsize = 12,
    #     padding = 10
    # ),
    widget.TextBox(
        # text = '',
        text = '',
        background = colors["red"],
        foreground = colors["green"],
        padding = -1,
        fontsize = 40
    ),
    # widget.UPowerWidget(
    #     foreground = colors["black"],
    #     background = colors["green"],
    #     fontsize = 12
    # ),
    widget.Battery(
        foreground = colors["black"],
        background = colors["green"],
        padding = 10,
        fontsize = 12,
        font = "JetBrains Mono SemiBold",
        format = "  {percent:2.0%} ({hour:d}h{min:02d})"
    ),
    widget.TextBox(
        # text = '',
        text = '',
        background = colors["green"],
        foreground = colors["magenta"],
        padding = -1,
        fontsize = 40
    ),
    widget.Volume(
        foreground = colors["black"],
        background = colors["magenta"],
        fontsize = 16,
        font = "JetBrains Mono SemiBold",
        fmt = ' : {} ',
        padding = 10,
        emoji = False,
        emoji_list = ['󰝟', '󰕿', '󰖀', '󰕾']
        ),
    # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
    # widget.StatusNotifier(),
    widget.TextBox(
        # text = '',
                    text = '',
        background = colors["magenta"],
        foreground = colors["blue"],
        padding = -1,
        fontsize = 40
    ),
    widget.Clock(
        fontsize = 12,
        foreground = colors["black"],
        background = colors["blue"],
        font = "JetBrains Mono SemiBold",
        format = "%A, %d %B - %H:%M ",
        padding = 10
    ),
]

# wall = "~/.dotfiles/wallpapers/star-wars-naboo-wallpapers.png"
# wall = "~/.dotfiles/wallpapers/mountain-and-river-wallpapers.jpg"
# wall = "~/.dotfiles/wallpapers/mountains-and-river-4k-wallpapers.jpg"
# wall = "~/.dotfiles/wallpapers/nature4.jpg"
wall = "~/.dotfiles/wallpapers/evergreentrees2.jpg"
screens = [
    Screen(
        wallpaper=wall,
        wallpaper_mode="fill",
        top=bar.Bar(
            widget_list,
            28,
            border_width=[0, 0, 0, 0],  # Draw top and bottom borders
            border_color=[colors["bg"]] * 4,  # Borders are magenta
            margin = 4,
            background = colors["red"] + "AA"
        ),
    ),
    Screen(
        wallpaper="~/.dotfiles/wallpapers/evergreentrees2.jpg",
        wallpaper_mode="fill",
        top=bar.Bar(
            widget_list_second,
            28,
            border_width=[0, 0, 0, 0],  # Draw top and bottom borders
            border_color=[colors["bg"]] * 4,  # Borders are magenta
            margin = 4,
            background = colors["red"] + "AA"
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
