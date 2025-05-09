# Aliases
alias v=nvim
alias zz='cd "$(fzf --walker=dir --preview "ls -lh --color=always {}")"'
alias z="fzf  --walker=file --multi --preview='bat {} --style=numbers,changes'"
alias d="dotnet"
alias yay="yay --sudoloop"
alias x="xclip -r -selection clipboard"
alias tm="tmux "
alias ta="tmux a"

# Helper Functions

vman(){
    man $1 | nvim - -c 'set ft=man'
}
vcurl() {
    curl  -s -X GET $1 ${@:2} | nvim -
}

jcurl() {
    curl -s -X GET $1 ${@:2} | jq | nvim - -c 'set ft=json'
}

hcurl() {
    curl -s -X GET $1 ${@:2} | nvim - -c 'set ft=html' 
}
pr() {
    fzfcmd() {
        fzf --height 33 --layout=reverse --select-1 --exit-0
    }
    local remote=$(git remote | fzfcmd)
    local pr_ref=$(git ls-remote | grep 'refs/pull/.*/head' | awk -F' ' '{print $2}' | fzfcmd)
    local pr_number=$(echo $pr_ref | awk -F'/' '{print $3}')

    if [ -d ./.git ]; then
        $(git checkout pr-$pr_number)
        if [ $? -ne 0 ]; then
            git fetch $remote pull/$pr_number/head:pr-$pr_number 
            git checkout pr-$pr_number
        fi
    fi
}

to_pdf() {
    if [ -z "$1" ]; then
        echo "Usage: to_pdf <file> [pandoc_options]"
        return 1
    fi

    if [ -f "$1" ]; then
        pandoc "$1" -o "${1%.*}.pdf" --pdf-engine=pdfroff $2
    fi
}

md_to_pdf() { 
    if [ -z "$1" ]; then
        echo "Usage: md_to_pdf <directory> [pandoc_options]"
        return 1
    fi
    for file in "$1"/*.md; do
        if [ -f "$file" ]; then
            pandoc "$file" -o "${file%.md}.pdf" --pdf-engine=pdfroff $2
        fi
    done
}

# ZHS Config
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git node )
source $ZSH/oh-my-zsh.sh
zstyle ':omz:update' mode disabled  # disable automatic updates


# PALTFORM RELATED
export LANG=en_US.UTF-8
export VISUAL='nvim'
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

export ARCHFLAGS="-arch x86_64"
