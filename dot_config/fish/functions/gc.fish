function gc
  if test -n "$argv"
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

    git commit -m "$prefix: $argv"
  else
      git commit --amend --no-edit
  end
end
