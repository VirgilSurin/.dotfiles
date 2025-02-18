#!/usr/bin/env bash
get_audio_outputs() {
    wpctl status | awk '/Sinks:/,/(Sink endpoints|Source endpoints)/' | grep -E "^\s*[0-9]+\.\s" | sed -E 's/^\s*[0-9]+\.\s//'
}

get_current_sink() {
    wpctl status | grep -E "^\s*[0-9]+\.\s.*\*" | sed -E 's/^\s*[0-9]+\.\s//; s/\*.*//'
}

set_default_sink() {
    local sink_name="$1"
    local sink_id=$(wpctl status | grep -E "^\s*[0-9]+\.\s$sink_name" | awk '{print $1}' | sed 's/\.//')
    if [[ -n "$sink_id" ]]; then
        wpctl set-default "$sink_id"
        dunstify "Audio Output Changed" "Switched to: $sink_name"
    else
        dunstify "Error" "Failed to find sink: $sink_name"
    fi
}

main() {
    local outputs=$(get_audio_outputs)
    local current_sink=$(get_current_sink)
    local selected_sink=$(echo "$outputs" | rofi -dmenu -p "Select Audio Output" -selected-row $(echo "$outputs" | grep -n "$current_sink" | cut -d: -f1))

    if [[ -n "$selected_sink" ]]; then
        set_default_sink "$selected_sink"
    fi
}
main
