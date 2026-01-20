#!/bin/sh
set -eu
set -f

TARGET_DIR="${DBI_VALIDATE_DIR:-/var/www/html/nsw_games}"
VALIDATE="${DBI_VALIDATE_FILENAMES:-1}"
DEBUG="${DBI_VALIDATE_DEBUG:-0}"

case "$VALIDATE" in
  0|false|FALSE|no|NO) exit 0 ;;
esac

if [ ! -d "$TARGET_DIR" ]; then
  echo "DBI filename check: directory not found: $TARGET_DIR"
  exit 1
fi

LC_ALL=C
export LC_ALL

is_bad_name() {
  name="$1"

  # Reject empty, leading/trailing space, or trailing dot.
  case "$name" in
    "") return 0 ;;
    " "*|*" ") return 0 ;;
    *.) return 0 ;;
  esac

  # Reject names containing characters outside a safe ASCII allowlist.
  if printf '%s' "$name" | grep -q "[^]A-Za-z0-9._() [+'-]"; then
    return 0
  fi

  return 1
}

tmp_bad="$(mktemp)"

find "$TARGET_DIR" -mindepth 1 -print0 | while IFS= read -r -d '' path; do
  rel="${path#$TARGET_DIR/}"
  if [ "$DEBUG" = "1" ]; then
    echo "DBI filename check: path=$path"
  fi
  segment="$rel"
  while :; do
    part="${segment%%/*}"
    if is_bad_name "$part"; then
      printf '%s\n' "$path" >> "$tmp_bad"
      break
    fi
    if [ "$segment" = "$part" ]; then
      break
    fi
    segment="${segment#*/}"
  done
done

if [ -s "$tmp_bad" ]; then
  while IFS= read -r bad_path; do
    echo "DBI filename check: invalid name: $bad_path"
  done < "$tmp_bad"
  bad_count="$(wc -l < "$tmp_bad" | tr -d ' ')"
  rm -f "$tmp_bad"
  echo "DBI filename check: found $bad_count invalid path(s)."
  exit 1
fi

rm -f "$tmp_bad"

echo "DBI filename check: OK"
