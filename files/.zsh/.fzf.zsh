# Setup fzf
# ---------
if [[ ! "$PATH" == */home/stevan/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/stevan/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/stevan/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/stevan/.fzf/shell/key-bindings.zsh"
