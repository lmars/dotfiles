source ~/.bash/aliases
source ~/.bash/completion
source ~/.bash/env
source ~/.bash/functions

# Machine specific script
if [ -f ~/.bash/local ]; then
    source ~/.bash/local
fi
