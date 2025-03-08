#!/usr/bin/env python3
import io
import os
import json
import shlex
import subprocess
import sys

os.environ["LC_NUMERIC"] = "C"
sinks = json.loads(subprocess.check_output(shlex.split("pactl -f json list sinks")))

current = (
    subprocess.check_output(shlex.split("pactl get-default-sink"))
    .decode("utf8")
    .strip()
)

descriptions = [sink["description"] for sink in sinks]
current = [i for (i, s) in enumerate(sinks) if s["name"] == current][0]

p = subprocess.Popen(
    shlex.split(f"rofi -dmenu -selected-row {current}"),
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
)
selected = p.communicate(input="\n".join(descriptions).encode("utf8"))[0].decode("utf8").strip()
selected_name = [s["name"] for s in sinks if s["description"] == selected][0]
subprocess.check_call(shlex.split(f"pactl set-default-sink {selected_name}"))
