function gcf
  if not git rev-parse --git-dir >/dev/null 2>&1
    echo "Not a git repository"
    return 1
  end

  set -l git_dir (git rev-parse --git-dir)
  if not test -f "$git_dir/COMMIT_EDITMSG"
    echo "No previous commit message found"
    return 1
  end

  git commit -F "$git_dir/COMMIT_EDITMSG" $argv
end
