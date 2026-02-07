function gc!
    if test -n "$argv"
        git commit --amend -m "$argv"
    else
        git commit --amend --no-edit
    end
end
