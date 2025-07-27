{ config, lib, pkgs, ... }:

{
    services.dunst = {
        enable = true;
        settings = {
            global = {
                follow = "keyboard";
                indicate_hidden = true;

                offset = "10x34";

                notification_height = 0;

                separator_height = 2;

                padding = 8;
                horizontal_padding = 8;
                text_icon_padding = 0;
                frame_width = 2;


                sort = true;
                idle_threshold = 120;
                line_height = 0;
                markup = "full";
                alignment = "left";
                vertical_alignment = "center";
                show_age_threshold = 60;
                word_wrap = true;
                stack_duplicates = true;
                hide_duplicate_count = false;

                progress_bar = true;
                progress_bar_corner_radius = 5;

                layer = "overlay";

                show_indicators = true;

                min_icon_size = 0;
                max_icon_size = 48;


                dmenu = "/usr/bin/rofi -p dunst:";
                browser = "/usr/bin/brave --new-tab";

                title = "Dunst";
                class = "Dunst";

                corner_radius = 0;
            };

            urgency_low = {
                timeout = 5;
            };

            urgency_normal = {
                timeout = 5;
            };

            urgency_critical = {
                timeout = 10;
            };

            quick_disappear = {
                summary = "test";
                timeout = 1;
            };

        };
    };
}
