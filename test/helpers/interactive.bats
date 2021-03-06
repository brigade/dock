#!/usr/bin/env bats

load ../utils

setup() {
  destroy_all_containers
  original_dir="$(pwd)"
  cd "$(create_repo)"
}

teardown() {
  cd "${original_dir}"
}

@test "returns true when standard input is a TTY" {
  file .dock <<-EOF
image alpine:latest

if interactive; then
  touch is_interactive
fi
if ! interactive; then
  touch is_not_interactive
fi
EOF

  run script --return -c "dock echo" /dev/null
  [ "$status" -eq 0 ]
  [ -e is_interactive ]
  [ ! -e is_not_interactive ]
}

@test "returns false when standard input is not a TTY" {
  file .dock <<-EOF
image alpine:latest

if interactive; then
  touch is_interactive
fi
if ! interactive; then
  touch is_not_interactive
fi
EOF

  echo | dock echo
  [ ! -e is_interactive ]
  [ -e is_not_interactive ]
}
