source ~/.bash/aliases
source ~/.bash/completion
source ~/.bash/env

# Custom script
if [ -f ~/.bash_custom ]; then
    . ~/.bash_custom
fi
