#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

failures=0

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  failures=$((failures + 1))
}

check_no_ds_store() {
  local matches
  matches="$(find . -name .DS_Store -print)"
  if [[ -n "$matches" ]]; then
    printf '%s\n' "$matches" >&2
    fail "remove .DS_Store files"
  fi
}

check_trailing_whitespace() {
  local files
  files="$(find README.md .gitignore scripts skills -type f 2>/dev/null | sort)"
  if [[ -n "$files" ]] && grep -nE '[[:blank:]]$' $files >/tmp/java-skill-trailing-whitespace.$$; then
    cat /tmp/java-skill-trailing-whitespace.$$ >&2
    rm -f /tmp/java-skill-trailing-whitespace.$$
    fail "remove trailing whitespace"
  else
    rm -f /tmp/java-skill-trailing-whitespace.$$
  fi
}

check_skill_links() {
  local skill_file="skills/java-enterprise-engineering/SKILL.md"
  local target
  while IFS= read -r target; do
    if [[ ! -f "skills/java-enterprise-engineering/$target" ]]; then
      fail "missing linked reference from SKILL.md: $target"
    fi
  done < <(grep -Eo 'references/[a-z0-9-]+\.md' "$skill_file" | sort -u)
}

check_reference_sections() {
  local required=(
    "Purpose"
    "When to Use"
    "Java/Spring-Specific Rules"
    "Bad Practices"
    "Better Alternatives"
    "Review Checklist"
    "Common Mistakes"
    "Agent Instructions"
  )
  local file section
  while IFS= read -r file; do
    for section in "${required[@]}"; do
      if ! grep -q "^## $section$" "$file"; then
        fail "$file is missing required section: $section"
      fi
    done
  done < <(find skills/java-enterprise-engineering/references -maxdepth 1 -type f -name '*.md' | sort)
}

is_allowed_vague_phrase_hit() {
  local line="$1"
  case "$line" in
    README.md:*"clean code practices"*) return 0 ;;
    README.md:*"| Clean Code |"*) return 0 ;;
    README.md:*"clean-code.md"*"Clean code guidelines"*) return 0 ;;
    README.md:*"Refactor this service to follow SOLID principles"*) return 0 ;;
    skills/java-enterprise-engineering/SKILL.md:*"SOLID/Clean Code findings:"*) return 0 ;;
    skills/java-enterprise-engineering/SKILL.md:*"[Java Clean Code]"*) return 0 ;;
    skills/java-enterprise-engineering/references/java-agent-output-format.md:*"SOLID/Clean Code findings:"*) return 0 ;;
    skills/java-enterprise-engineering/references/java-clean-code.md:*"# Java Clean Code"*) return 0 ;;
  esac
  return 1
}

check_vague_phrases() {
  local phrase='best practices|clean code|maintainable|scalable|robust|proper|good design|production-ready|loosely coupled|highly cohesive|easy to test|follow SOLID|write tests|handle errors|improve readability|use design patterns|separate concerns|add validation|secure the endpoint|optimize performance|use architecture|use abstraction'
  local pattern="(^|[^[:alnum:]_-])($phrase)([^[:alnum:]_-]|$)"
  local unexpected=0
  local line
  while IFS= read -r line; do
    if ! is_allowed_vague_phrase_hit "$line"; then
      printf '%s\n' "$line" >&2
      unexpected=1
    fi
  done < <(grep -RInEi "$pattern" README.md skills/java-enterprise-engineering || true)
  if [[ "$unexpected" -ne 0 ]]; then
    fail "unexpected vague phrase hit"
  fi
}

check_no_ds_store
check_trailing_whitespace
check_skill_links
check_reference_sections
check_vague_phrases

if [[ "$failures" -ne 0 ]]; then
  printf 'Quality gate failed with %s issue(s).\n' "$failures" >&2
  exit 1
fi

printf 'Quality gate passed.\n'
