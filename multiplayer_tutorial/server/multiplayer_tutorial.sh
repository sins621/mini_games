#!/bin/sh
echo -ne '\033c\033]0;multiplayer_tutorial\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/multiplayer_tutorial.x86_64" "$@"
