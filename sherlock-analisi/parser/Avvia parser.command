#!/bin/zsh
parser_dir="$(cd -- "$(dirname -- "$0")" && pwd)"
exec python3 -B "$parser_dir/sherlock_parser.py" "$@"
