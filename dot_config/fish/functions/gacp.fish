function gacp
  set -l prefixes \
    "feat" \
    "fix" \
    "docs" \
    "style" \
    "refactor" \
    "perf" \
    "test" \
    "chore" \
    "ci" \
    "build"

  set -l selected (printf "%s\n" $prefixes | fzf --height=40% --prompt="Select commit type: ")

  if test -z "$selected"
    echo "Commit cancelled"
    return 1
  end

  set -l prefix (string split ":" $selected)[1]

  git add .
  git commit -m "$prefix: $argv"
  git push
end
