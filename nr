#!/bin/env bash

[ ! -v NTSH_DIR ] && source "utils.sh" || source "$NTSH_DIR/utils.sh"

handle_help "$1" "rename a note and all its references"

if [[ -z "$1" || -z "$2" ]]; then
  echo "please provide a target note name and new name"
  exit 1
fi

# target, new name, path
rename_note() {
  sed -i -E "s/^title: $1/title: $2/g" "$3"
  sed -i -E "s/^# .*$/# $2/" "$3"

  md_path=$(dirname "$3")
  if [[ -z "$md_path" ]]; then
    md_path="./$2.md"
  else
    md_path+="/$2.md"
  fi

  mv "$3" "$md_path"
}

# target, new name, path
rename_refs() {
  ref_files=$(find . \( -path "./.git" -o -path "./.obsidian" \) -prune -o -type f -print0 | xargs -0 grep -Eli "$1")

  md_path=$(dirname "$3")
  if [[ -z "$md_path" ]]; then
    md_path="./$2.md"
  else
    md_path+="/$2.md"
  fi

  esc_1=$(printf '%s' "$1" | sed 's/[&/\]/\\&/g')
  esc_2=$(printf '%s' "$2" | sed 's/[&/\]/\\&/g')
  esc_md_path=$(printf '%s' "$md_path" | sed 's/[&/\]/\\&/g')

  for file in $ref_files; do
    sed -i -E "s/\[\[$esc_1(\|[^]]*)?\]\]/\[\[$esc_2\]\]/g" "$file"
    sed -i -E "s/\(.*$esc_1\.md\)/\($esc_md_path\)/g" "$file"
  done
}

escaped_name=$(printf '%s\n' "$1" | sed 's/[][\\.^$*]/\\&/g')

path="$(find -type f -name "$1.md")"

if [[ -z "$path" ]]; then
  echo "note does not exist"
  exit 1
fi

rename_note "$escaped_name" "$2" "$path"
rename_refs "$escaped_name" "$2" "$path"
