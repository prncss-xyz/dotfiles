function gmk
  gh repo create (basename $PWD) --public --source=.
  git push
end
