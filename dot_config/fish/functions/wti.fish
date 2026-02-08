function wti --description "Init a bare repo for git worktrees" --argument-names REPO
  set -l DIR (string split -r -m1 -f2 / $REPO; or echo $REPO)
  mkdir -p $HOME/projects/$DIR
  cd $HOME/projects/$DIR
  gh repo clone $REPO .bare -- --bare
  echo "gitdir: ./.bare" > .git
end
