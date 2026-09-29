#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
temp_root="$(mktemp -d)"
trap 'rm -rf "$temp_root"' EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_path() {
  [[ -e "$1" || -L "$1" ]] || fail "expected path: $1"
}

assert_no_path() {
  [[ ! -e "$1" && ! -L "$1" ]] || fail "unexpected path: $1"
}

list_output="$($repo_root/install.sh --list)"
grep -qx 'project-research' <<<"$list_output" || fail "--list omitted project-research"
grep -qx 'design-directions' <<<"$list_output" || fail "--list omitted design-directions"

single_dest="$temp_root/single"
"$repo_root/install.sh" --dest "$single_dest" --skill project-research >/dev/null
assert_path "$single_dest/project-research"
assert_no_path "$single_dest/design-directions"
assert_no_path "$single_dest/audit-skills"

multi_dest="$temp_root/multi"
"$repo_root/install.sh" --dest "$multi_dest" \
  --skill project-research --skill design-directions >/dev/null
assert_path "$multi_dest/project-research"
assert_path "$multi_dest/design-directions"
assert_no_path "$multi_dest/audit-skills"

unknown_dest="$temp_root/unknown"
if "$repo_root/install.sh" --dest "$unknown_dest" --skill does-not-exist \
  >"$temp_root/unknown.out" 2>"$temp_root/unknown.err"; then
  fail "unknown skill unexpectedly succeeded"
fi
grep -q 'Unknown skill: does-not-exist' "$temp_root/unknown.err" || \
  fail "unknown skill error was not actionable"
assert_no_path "$unknown_dest"

empty_dest="$temp_root/empty"
if "$repo_root/install.sh" --dest "$empty_dest" \
  >"$temp_root/empty.out" 2>"$temp_root/empty.err"; then
  fail "install without an explicit selection unexpectedly succeeded"
fi
grep -q 'Select at least one skill or use --all' "$temp_root/empty.err" || \
  fail "empty selection error was not actionable"
assert_no_path "$empty_dest"

all_dest="$temp_root/all"
"$repo_root/install.sh" --dest "$all_dest" --all >/dev/null
assert_path "$all_dest/project-research"
assert_path "$all_dest/audit-skills"

echo "PASS: install.sh selection behavior"
