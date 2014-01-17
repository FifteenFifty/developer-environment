# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

export PATH="/usr/lib/colorgcc/bin:$PATH"
source $ZSH/oh-my-zsh.sh
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig"
export CXX="g++"
export CCACHE_PREFIX="icecc"

# Customize to your needs...

if [ "${TERM}" = "xterm" ]
then
    export TERM="xterm-256color"
fi

zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'

function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
}

function battery_charge {
    echo `$BAT_CHARGE` 2>/dev/null
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function hg_prompt_info {
    hg prompt --angle-brackets "\
< on %{$fg[magenta]%}<branch>%{$reset_color%}>\
< at %{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
%{$fg[green]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
}

PROMPT='%{$fg[magenta]%}%n%{$reset_color%} in %{$fg[green]%}$(collapse_pwd)%{$reset_color%}$(hg_prompt_info)$(git_prompt_info) $(virtualenv_info)$(prompt_char) '

RPROMPT='[%j]'

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

cd Projects/starfleet

#alias go="git checkout"
alias cap="/home/mbissenden/Projects/dev-tools/gen-patch.py -u && git commit -a -m 'Uploaded patch file for review.'"
alias gen-patch="cap"
alias ca="git commit -a"
alias ducks="doxygen"
alias vi=vim
alias rc="rm /home/mbissenden/Projects/starfleet/m4/*"
alias ut=""
alias stuff="echo $(git_prompt_info)"
alias m="make install -j"
alias ra="/home/mbissenden/rebuild-all"

function go()
{
    branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* r\(.*\)/\1/')
    /home/mbissenden/Projects/rev-tools/rev-tools.sh -r ${branch} > /dev/null 2>&1

    if [ "$@" = "lunch" ]
    then
        hamster-cli stop
        hamster-cli start lunch
        echo "Enjoy your lunch!"
        return
    fi

    git review "$@";
    hamster-cli stop;
    hamster-cli start "$@";
}
