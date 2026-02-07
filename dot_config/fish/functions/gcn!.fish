function gcn!
    if test -n "$argv"
        git commit --amend --no-verify -m "$argv"
    else
        git commit --amend --no-verify --no-edit
    end
end
