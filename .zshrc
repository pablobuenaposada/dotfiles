# oh-my-zsh crap
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
ZSH_CUSTOM="$HOME/.oh-my-zsh-custom/"
plugins=(git)

# crap for showing elapsed time
preexec() {
    TIMER_START=$SECONDS
}
precmd() {
    if [[ -n "$TIMER_START" ]]; then
        TIMER_ELAPSED=$((SECONDS - TIMER_START))
        # Format the elapsed time as HH:MM:SS if > 60 seconds
        if (( TIMER_ELAPSED >= 60 )); then
            ELAPSED_TIME=$(printf '%d:%02d' $((TIMER_ELAPSED/60)) $((TIMER_ELAPSED%60)))
        else
            ELAPSED_TIME="${TIMER_ELAPSED}s"
        fi
    else
        ELAPSED_TIME=""
    fi
}
RPROMPT='%F{yellow}⌛ $ELAPSED_TIME%f'

# crap for changing background color by folder
tab-color() {
    echo -ne "\033]6;1;bg;red;brightness;$1\a"
    echo -ne "\033]6;1;bg;green;brightness;$2\a"
    echo -ne "\033]6;1;bg;blue;brightness;$3\a"
}
function set_background_color() {
    local folder="$PWD"

    # Default background color (e.g., black)
    local color="\033]11;#000000\007"
    tab-color 0 0 0

    # Change the background color based on the folder
    if [[ "$folder" == *"northwood"* ]]; then
        color="\033]11;#051b1f\007"
        tab-color 0 0 255
    elif [[ "$folder" == *"prescott"* ]]; then
        color="\033]11;#1f0d05\007"
        tab-color 255 0 0
    fi

    # Apply the color
    echo -e "$color"
}
if [[ "$SHELL" =~ "zsh" ]]; then
    autoload -U add-zsh-hook
    add-zsh-hook chpwd set_background_color
else
    PROMPT_COMMAND=set_background_color
fi

source $ZSH/oh-my-zsh.sh
