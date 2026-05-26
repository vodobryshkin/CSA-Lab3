#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <file> <arch> [extra wrench-fmt args...]"
  echo "Example: $0 acc32/is_binary_palindrome.s acc32 --inplace"
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

docker run --rm -it \
  -v "$PWD:/work" \
  -w /work \
  ryukzak/wrench:latest \
  wrench-fmt "$FILE" --isa "$ARCH" "$@"