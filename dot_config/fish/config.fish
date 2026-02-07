if status is-interactive
  fish_config theme choose Rosé\ Pine
  set fish_greeting ""
  abbr c bat  
  abbr cm chezmoi
  abbr cmi chezmoi add
  abbr cmr chezmoi forget
  abbr cmap chezmoi apply
  abbr cme chezmoi edit
  abbr cmcd chezmoi cd
  abbr cmdd chezmoi diff
	abbr d ddgr --rev
	abbr dw BROWSER=w3m ddgr --rev
  abbr n nvim
  abbr o xdg-open
  abbr t eza --tree --icons --git
  # https://github.com/jhillyerd/plugin-git/blob/83a0a865d5031c436d47c9e3ab3a269b5d601615/functions/__git.init.fish#L6
  abbr g git
  abbr ga git add
	abbr gaa git add --all
	abbr gba git branch --all
  abbr gsc git switch -c
  abbr gc git commit -m
  abbr gcn git commit --no-verify -m
  abbr gc! git commit --amend --no-edit
  abbr gcn! git commit --amend --no-verify --no-edit
  abbr gf git fetch
  abbr gp git push
  abbr gl git pull
  abbr gstd git stash drop
  abbr gstl git stash list
  abbr gstp git stash pop
  abbr gsts git stash show --text
  abbr grhh git reset --hard HEAD
  abbr gch git checkout HEAD --
  abbr ytx yt-dlp -x
  abbr yta yt-dlp -x --output "%(autonumber)02d %(title)s.%(ext)s"

  fzf --fish | source
	starship init fish | source
  zoxide init fish | source
end
