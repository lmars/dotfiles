# Hack to stop OSX path_helper screwing with the PATH in a tmux session
if [ ! -z $TMUX ] && [ -x /usr/libexec/path_helper ]; then
  PATH=""
  eval `/usr/libexec/path_helper -s`
fi

source ~/.bash/aliases
source ~/.bash/completion
source ~/.bash/functions
source ~/.bash/env

# Machine specific script
if [ -f ~/.bash/local ]; then
    source ~/.bash/local
fi
