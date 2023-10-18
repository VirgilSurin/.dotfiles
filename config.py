# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
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

from libqtile import bar, layout, widget, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
# from libqtile.utils import guess_terminal
from os.path import expanduser

mod = "mod4"
# terminal = guess_terminal()
myBrowser = "librewolf"
editor = "emacsclient -c -a 'emacs' "
terminal = "alacritty"

qtile.cmd_spawn("picom")

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
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
    Key([mod, "control", "shift"], "l", lazy.spawn(expanduser("~/.dotfiles/lock_screen.sh"), shell=True), desc="Lock the screen"),


    # app shortcut
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "b", lazy.spawn(myBrowser), desc="Launch my web browser"),
    Key([mod], "e", lazy.spawn(editor), desc="Launch my editor"),
    Key([mod], "v", lazy.spawn(editor + "--eval '(dirvish)'"), desc="Open file manager"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Sound
    Key([], "xF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer sset Master 5%-"), desc="Lower Volume by 5%"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer sset Master 5%+"), desc="Raise Volume by 5%"),

    # brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),

]


groups = [Group(i) for i in "asdfuiop"]

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
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

colors = [["#282c34", "#282c34"], # 0
          ["#1c1f24", "#1c1f24"], # 1
          ["#dfdfdf", "#dfdfdf"], # 2
          ["#ff6c6b", "#ff6c6b"], # 3
          ["#98be65", "#98be65"], # 4
          ["#da8548", "#da8548"], # 5
          ["#51afef", "#51afef"], # 6
          ["#c678dd", "#c678dd"], # 7
          ["#46d9ff", "#46d9ff"], # 8
          ["#a9a1e1", "#a9a1e1"]] # 9

# LAYOUTS
layout_theme = {"border_width": 4,
                "margin": 16,
                "border_focus": "#e1acff",
                "border_normal": "#1D2330"
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
    background = colors[0],
    foreground = colors[2]
)
sep = widget.Sep(linewidth = 0,
                 padding = 6,
                 foreground = colors[2],
                 background = colors[0])
sep_bar = widget.TextBox(
                    text = '|',
                    background = colors[0],
                    foreground = '#474747',
                    padding = 2,
                    fontsize = 26
                )
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        wallpaper="~/Pictures/ign_astronaut.png",
        wallpaper_mode="fill",
        top=bar.Bar(
            [
                sep,
                widget.GroupBox(
                    padding_y = 5,
                    padding_x = 5,
                    borderwidht = 1,
                    active = colors[2],
                    inactive = colors[2],
                    rounded = True,
                    highlight_method = "block",
                    this_current_screen_border = colors[5],
                    this_screen_border = colors[1],
                    other_current_screen_border = colors[0],
                    other_screen_border = colors[0],
                    foreground = colors[2],
                    background = colors[0]
                ),
                sep,
                sep_bar,
                widget.Prompt(),
                widget.WindowName(
                    fontsize = 12,
                    padding = 5,
                    max_chars = 40
                ), # TODO : center the window name
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                sep,
                sep_bar,
                widget.CurrentLayout(
                    foreground = colors[8],
                    background = colors[0],
                    padding = 5,
                    fontsize = 12,
                ),
                sep,
                sep_bar,
                widget.Wlan(
                    disconnected_message = "󰖪 Disconnected",
                    interface = "wlp6s0", # use "nmcli device status" to know what the write here
                    foreground = colors[3],
                    background = colors[0],
                    fontsize = 12,
                    padding = 5
                ),
                widget.Net(
                    interface = "wlp6s0",
                    format = 'Net: {down} ↓↑ {up}',
                    foreground = colors[3],
                    background = colors[0],
                    fontsize = 12,
                    padding = 5
                ),
                sep,
                sep_bar,
                widget.Battery(
                    foreground = colors[4],
                    padding = 5,
                    fontsize = 12,
                    format = "{char} {percent:2.0%}",
                    charge_char = "󰂄",
                    discharge_char = "󱟤",
                    empty_char = "󱊡",
                    full_char = "󱊣"),
                sep,
                sep_bar,
                widget.Volume(
                    foreground = colors[7],
                    background = colors[0],
                    fontsize = 12,
                    fmt = 'Vol: {}',
                    padding = 5,
                    emoji = False),
                sep,
                sep_bar,
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),

                widget.Systray(),
                widget.Clock(
                    fontsize = 12,
                    foreground = colors[6],
                    background = colors[0],
                    format = "%A, %B %d - %H:%M ",
                    padding = 5
                ),
                sep,
            ],
            24,
            border_width=[2, 2, 2, 2],  # Draw top and bottom borders
            border_color=[colors[1][0]] * 4  # Borders are magenta
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
