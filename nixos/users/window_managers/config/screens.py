from libqtile import bar, widget
from libqtile.config import Screen
from qtile_extras.widget.decorations import BorderDecoration, RectDecoration
from themes import One as colors

widget_defaults = dict(
    font="Ubuntu Bold",
    fontsize=12,
    padding=0,
    background=colors["bg"],
)

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

def create_separator():
    return widget.Sep(
        linewidth=0,
        padding=6,
        margin=10,
        foreground=colors["fg"],
        background=colors["bg"]
    )

def create_bar_separator():
    return widget.TextBox(
        text='|',
        background=colors["bg"],
        foreground=colors["fg"],
        padding=4,
        fontsize=14
    )

def create_widgets():
    return [
        widget.TextBox(
            text='󱄅',
            fontsize=26,
            foreground = colors["blue"],
            padding=10,
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
        create_bar_separator,
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

def init_screens():
    wall = "~/.dotfiles/wallpapers/one-graph.png"

    screens = [
        Screen(
            wallpaper=wall,
            wallpaper_mode="fill",
            top=bar.Bar(
                create_widgets(),
                32,
                border_width=[0, 0, 0, 0],
                border_color=[colors["black"]] * 4,
                margin=0,
                background=colors["bg"] + "00",
            ),
        ),
        Screen(
            wallpaper=wall,
            wallpaper_mode="fill",
            top=bar.Bar(
                create_widgets(),
                32,
                border_width=[0, 0, 0, 0],
                border_color=[colors["black"]] * 4,
                margin=[0, 0, 0, 0],
                background=colors["bg"] + "00",
            ),
        ),
    ]
    return screens
