cd
rsync -avz --exclude '*.lock' .gnupg $USER@$ARGv[1]:.gnupg
rsync -avz -e 'ssh -p 2222' --exclude '*.lock' .gnupg prncss@192.168.167.160:.gnupg
rsync -avz --files-from=push-files.txt . $USER@$ARGV[pass1]:
# rsync -av --ignore-existing .ssh/* prncss@odonata.local:.ssh/
# rsync -av --ignore-existing .ssh/* prncss@odonata.local:.ssh/
