import os
import subprocess
from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal, send_notification
from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration, RectDecoration
from libqtile.command.client import InteractiveCommandClient
import themes

colors = themes.One

mod = "mod4"
terminal = "alacritty"
browser = "firefox"
editor = "emacsclient -c -a 'emacs' "

@hook.subscribe.startup_once
def autostart():
    subprocess.run(['systemctl', '--user', 'start', 'dunst.service'])
    os.system("xset -dpms")
    os.system("xset s off")

directions = {
    'left': 'n',
    'right': 'o',
    'up': 'i',
    'down': 'e'
}

keys = [
    *[
        Key(
            [mod],
            directions[direction],
            getattr(lazy.layout, direction)(),
            desc=f"Move focus {direction}"
        )
        for direction in directions
    ],
    *[
        Key(
            [mod, "shift"],
            directions[direction],
            getattr(lazy.layout, f"shuffle_{direction}")(),
            desc=f"Move window {direction}"
        )
        for direction in directions
    ],
    *[
        Key(
            [mod, "control"],
            directions[direction],
            getattr(lazy.layout, f"grow_{direction}")(),
            desc=f"Grow window {direction}"
        )
        for direction in directions
    ],

    # Split and layout controls
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),

    # Grow/shrink windows left/right for specific layouts
    Key([mod], "equal",
        lazy.layout.grow_left().when(layout=["bsp", "columns"]),
        lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left"
        ),
    Key([mod], "minus",
        lazy.layout.grow_right().when(layout=["bsp", "columns"]),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left"
        ),

    # Layout and window management
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),

    # Screen management
    Key([mod], "y", lazy.next_screen()),
    Key([mod, "shift"], "y", lazy.prev_screen()),

    # System controls
    Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer sset Master 5%-"), desc="Lower Volume by 5%"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer sset Master 5%+"), desc="Raise Volume by 5%"),

    # Brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),

    # System commands
    Key([mod, "control"], "f", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "control"], "z", lazy.spawn("custom-i3lock"), desc="Lock screen"),

    # Application launchers
    Key([mod], "p", lazy.spawn("rofi -show drun"), desc="Launch apps"),
    Key([mod, "shift"], "p", lazy.spawn("rofi -show run"), desc="Run commands"),
    Key([mod, "shift"], "m", lazy.spawn("monitor-switch"), desc="Change monitor config"),
    Key([mod, "control"], "m", lazy.spawn("rofi -show calc -modi calc -no-show-match -no-sort"), desc="Launch calculator"),
    Key([mod], "Return", lazy.spawn("alacritty"), desc="Launch terminal"),
    Key([mod], "b", lazy.spawn(browser), desc="Launch browser"),
    Key([mod], "x", lazy.spawn(editor), desc='Emacs Dashboard'),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "m", lazy.spawn("dolphin"), desc="Open file manager"),
    Key([], "Print", lazy.spawn("flameshot gui")),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


# Groups
groups = [
    Group(name='a', label=' '),
    Group(name='r', label='󰖟'),
    Group(name='s', label='󰈙'),
    Group(name='t', label=''),
    Group(name='l', label='󰍦', matches=[Match(wm_class="signal")], layout="columns"),
    Group(name='u', label='󰓇', matches=[Match(wm_class="spotify")], layout="columns"),
]

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

# Layouts
layout_theme = {"border_width": 3,
                "margin": 0,
                "border_focus": colors["blue"],
                "border_normal": colors["black"]
                }
layouts = [
    layout.Columns(**layout_theme,
                   border_on_single = True,
                   border_focus_stack = colors["magenta"],
                   border_normal_stack = colors["bg"]
                   ),
    # layout.MonadTall(**layout_theme,
    #                  ratio = 0.6,
    #                  ),
    layout.Max(**layout_theme),
]

widget_defaults = dict(
    font = "Ubuntu Bold",
    fontsize = 12,
    padding = 0,
    background = colors["bg"],
)
sep = widget.Sep(linewidth = 0,
                 padding = 6,
                 margin = 10,
                 foreground = colors["fg"],
                 background = colors["bg"])
sep_bar = widget.TextBox(
                    text = '|',
                    background = colors["bg"],
                    foreground = colors["fg"],
                    padding = 4,
                    fontsize = 14
                )
extension_defaults = widget_defaults.copy()

decoration_group2 = {
    "decorations": [
        RectDecoration(colour=colors["black"], radius=15, filled=True, group=True, clip=True, extrawidth=0)
    ],
    #"padding": 10,
}
decoration_group = {
    "decorations": [
        RectDecoration(colour="#2d3139",
                       line_colour = colors["green"],
                       line_width = 2,
                       radius=15,
                       clip=False,
                       padding_x=0,
                       padding_y=-1,
                       filled=True,
                       group=True)
    ],
    "padding": 0,
}
# Widget function
def create_widget():
    return [
        widget.TextBox(
            text='󱄅',
            fontsize=26,
            foreground = colors["blue"],
            #margin=13,
            padding=10,
            #**decoration_group,
        ),
        widget.Spacer(length=4),
        widget.GroupBox(
            fontsize = 16,
            margin_x = 10,
            margin_y = 5,
            borderwidht = 3,
            padding_x = 2,
            active = colors["blue"],
            inactive = colors["fg"],
            center_aligned=True,
            highlight_method = "line",
            rounded = True,
            highlight_color = ["#565c6400"], # if using "line" as  highlight method
            this_current_screen_border = colors["green"],
            other_current_screen_border = colors["magenta"],

            this_screen_border = colors["magenta"],
            other_screen_border = colors["magenta"],

            foreground = colors["fg"],
            background = [colors["bg"]],
            **decoration_group,
        ),
        widget.Spacer(length=10),
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
            font = "JetBrains Mono",
            padding = 10,
            fontsize = 14,
        ),
        sep_bar,
        widget.WindowName(
            fontsize = 16,
            padding = 5,
            max_chars = 32,
            font = "Ubuntu",
            foreground = colors["fg"],
            background = colors["bg"],
        ),
        widget.Spacer(length = 8),
        widget.KeyboardLayout(
            configured_keyboards = [ "us", "workman" ],
            # mouse_callbacks = lazy.widget["keyboardlayout"].next_keyboard(),
            foreground = colors["orange"],
            background = colors["bg"],
            font = "JetBrains Mono SemiBold",
            fontsize = 14,
            padding = 4,
            decorations = [
                BorderDecoration(
                    colour = colors["orange"],
                    border_width = [0, 0, 3, 0],
                )
            ]
        ),
        widget.Spacer(length = 8),
        widget.Net(
            interface = "wlp6s0",
            format = "{up:^3.0f}{up_suffix} ↑↓ {down:^3.0f}{down_suffix}",
            foreground = colors["red"],
            background = colors["bg"],
            font = "JetBrains Mono SemiBold",
            fontsize = 14,
            padding = 4,
            decorations = [
                BorderDecoration(
                    colour = colors["red"],
                    border_width = [0, 0, 3, 0],
                )
            ]
        ),
        widget.Spacer(length = 8),
        widget.UPowerWidget(
            foreground = colors["green"],
            background = colors["bg"],
            fontsize = 14,
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
                    border_width = [0, 0, 3, 0],
                )
            ]
        ),
        widget.Battery(
            foreground = colors["green"],
            background = colors["bg"],
            padding = 0,
            fontsize = 14,
            font = "JetBrains Mono SemiBold",
            format = "{percent:2.0%} ({hour:d}h{min:02d})",
            decorations = [
                BorderDecoration(
                    colour = colors["green"],
                    border_width = [0, 0, 3, 0],
                )
            ]
        ),
        widget.Spacer(length = 8),
        widget.Volume(
            foreground = colors["magenta"],
            background = colors["bg"],
            fontsize = 14,
            font = "JetBrains Mono SemiBold",
            fmt = '  Vol: {} ',
            padding = 00,
            decorations = [
                BorderDecoration(
                    colour = colors["magenta"],
                    border_width = [0, 0, 3, 0],
                )
            ]
            ),
        widget.Spacer(length = 8),
        widget.Clock(
            fontsize = 14,
            foreground = colors["blue"],
            background = colors["bg"],
            font = "JetBrains Mono SemiBold",
            format = "⏱ %a, %d %b - %H:%M ",
            padding = 00,
            decorations = [
                BorderDecoration(
                    colour = colors["blue"],
                    border_width = [0, 0, 3, 0],
                )
            ]
        ),
        #widget.Systray(
        #    padding = 3,
        #    background = colors["bg"],
        #    foreground = colors["blue"],
        #    #**decoration_group,
        #),
        # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
        widget.Spacer(length = 8),
    ]

# Wallpaper
wall = "~/.dotfiles/wallpapers/one-graph.png"

# SCREENS
screens = [
    Screen(
        wallpaper=wall,
        wallpaper_mode="fill",
        top=bar.Bar(
            create_widget(),
            32,
            border_width=[0, 0, 0, 0],  # Draw top and bottom borders
            border_color=[colors["black"]] * 4,  # Borders are magenta
            margin = 0,
            background = colors["bg"] + "00"
        ),
    ),
    Screen(
        wallpaper=wall,
        wallpaper_mode="fill",
        top=bar.Bar(
            create_widget(),
            32,
            border_width=[0, 0, 0, 0],  # Draw top and bottom borders
            border_color=[colors["black"]] * 4,  # Borders are magenta
            margin = [0, 0, 0, 0],
            background = colors["bg"] + "00"
        ),
    ),
    # Screen(
    #     wallpaper = wall,
    #     wallpaper_mode="fill",
    #     top=bar.Bar(
    #         create_widget(),
    #         32,
    #         border_width=[0, 0, 0, 0],  # Draw top and bottom borders
    #         border_color=[colors["blue"]] * 4,  # Borders are magenta
    #         margin = 4,
    #         background = colors["bg"] + "00"
    #     ),
    # ),
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
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    **layout_theme,
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

auto_minimize = True
wl_input_rules = None
wl_xcursor_theme = None
wl_xcursor_size = 24
wmname = "LG3D"
