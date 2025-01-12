# oh my zsh crap
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

source $ZSH/oh-my-zsh.sh
