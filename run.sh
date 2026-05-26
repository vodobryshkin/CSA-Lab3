#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <file> <arch> [config] [extra wrench args...]"
  echo "Examples:"
  echo "  $0 acc32/is_binary_palindrome.s acc32"
  echo "  $0 acc32/is_binary_palindrome.s acc32 acc32/test.yaml"
  echo "  $0 acc32/is_binary_palindrome.s acc32 acc32/test.yaml -S"
}

if [[ $# -lt 2 ]]; then
  usage
  exit 1
fi

FILE="$1"
ARCH="$2"
shift 2

if [[ ! -f "$FILE" ]]; then
  echo "Error: file '$FILE' not found." >&2
  exit 1
fi

CONF_ARGS=()
if [[ $# -gt 0 && -f "$1" ]]; then
  CONF_ARGS=( -c "$1" )
  shift
fi

docker run --rm -it \
  -v "$PWD:/work" \
  -w /work \
  ryukzak/wrench:latest \
  wrench "$FILE" --isa "$ARCH" "${CONF_ARGS[@]}" "$@"