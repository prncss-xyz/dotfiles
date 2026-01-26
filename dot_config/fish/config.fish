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
	abbr gaa git add --all
  abbr gcam 'git add --all; git commit --amend --no-edit'
	abbr gba git branch --all
  abbr gsc git switch -c
  abbr grhh git reset --hard HEAD
  abbr gch git checkout HEAD --
  abbr ytx yt-dlp -x
  abbr yta yt-dlp -x --output "%(autonumber)02d %(title)s.%(ext)s"

  fzf --fish | source
	starship init fish | source
  zoxide init fish | source
end
