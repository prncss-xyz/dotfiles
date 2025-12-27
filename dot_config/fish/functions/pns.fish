function pns --description "Fuzzy-search pnpm scripts"
    if not test -f package.json
        echo "Error: package.json not found in the current directory."
        return 1
    end

    set -l script (jq -r '.scripts | keys[]' package.json | fzf --height 40% --layout=reverse --border --prompt="󰓅 Run Script: ")

    if test -n "$script"
        echo "Executing: pnpm run $script"
        pnpm run "$script"
    end
end
