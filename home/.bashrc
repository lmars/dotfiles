source ~/.bash/aliases
source ~/.bash/completion
source ~/.bash/functions
source ~/.bash/env

# Machine specific script
if [ -f ~/.bash/local ]; then
    source ~/.bash/local
fi
