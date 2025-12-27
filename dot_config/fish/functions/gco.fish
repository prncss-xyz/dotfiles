function gco
  set -l branch (git branch --all | grep -v (git rev-parse --abbrev-ref HEAD) | fzf | tr -d '[:space:]')
  if test -n "$branch"
    git checkout $branch
  end
end
