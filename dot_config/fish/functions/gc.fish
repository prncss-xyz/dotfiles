function gc
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

  read -P "Scope (optional): " -l scope
  read -P "Message: " -l msg

  set -l prefix (string split ":" $selected)[1]
  if test -n "$scope"
    set prefix "$prefix($scope)"
  end

  git commit -m "$prefix: $msg" $argv
end
