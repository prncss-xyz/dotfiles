function i --description "Install dependencies"
    if test -f pnpm-lock.yaml
        pnpm install $argv
    else if test -f bun.lockb; or test -f bun.lock
        bun install $argv
    else if test -f yarn.lock
        yarn install $argv
    else if test -f package-lock.json
        npm install $argv
    else if test -f package.json
        pnpm install $argv
    else if test -f go.mod
        go mod download $argv
    else
        echo "No lockfile or package.json found."
        return 1
    end
end
