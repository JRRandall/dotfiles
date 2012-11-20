#  File:        .zshrc
#  Author:      Justin Randall (randall AT gmail DOT com)
#  Version:     0.1
#  Created:     Mon Apr 09 10:00 AM 2012 EDT
#  Last Change: Mon Nov 19 10:00 PM 2012 EST
#  Description: Zsh configuration file
#  History:     none

# BASIC ENVIRONMENT
# set a reasonable path through the file system to start, and add other
# directories to it _only_ if they exist...
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
[ -d /opt/local/sbin      ] && PATH=/opt/local/sbin:${PATH}
[ -d /opt/local/bin       ] && PATH=/opt/local/bin:${PATH}
[ -d $HOME/bin            ] && PATH=${PATH}:$HOME/bin
[ -d /usr/X11/bin         ] && PATH=${PATH}:/usr/X11/bin
[ -d /usr/css/bin         ] && PATH=${PATH}:/usr/css/bin
[ -d /usr/dt/bin          ] && PATH=${PATH}:/usr/dt/bin
[ -d /usr/openwin/bin     ] && PATH=${PATH}:/usr/openwin/bin
[ -d /usr/ucb             ] && PATH=${PATH}:/usr/ucb
[ -d /usr/share/bin       ] && PATH=${PATH}:/usr/share/bin
[ -d /home/term/bin       ] && PATH=${PATH}:/home/term/bin
export PATH

MANPATH=/usr/man:/usr/local/man
[ -d /opt/local/man         ] && MANPATH=${MANPATH}:/opt/local/man
[ -d /usr/X11/man           ] && MANPATH=${MANPATH}:/usr/X11/man
[ -d /usr/dt/man            ] && MANPATH=${MANPATH}:/usr/dt/man
[ -d /usr/openwin/share/man ] && MANPATH=${MANPATH}:/usr/openwin/share/man
[ -d /usr/openwin/man       ] && MANPATH=${MANPATH}:/usr/openwin/man
[ -d /usr/share/man         ] && MANPATH=${MANPATH}:/usr/share/man
[ -d /usr/contrib/man       ] && MANPATH=${MANPATH}:/usr/contrib/man
export MANPATH

LD_LIBRARY_PATH=/lib:/usr/lib
[ -d /opt/local/lib   ] && LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/opt/local/lib
[ -d /usr/X11/lib     ] && LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/X11/lib
[ -d /usr/openwin/lib ] && LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/openwin/lib
[ -d /usr/dt/lib      ] && LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/dt/lib
[ -d /usr/share/lib   ] && LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/share/lib
[ -d /usr/local/lib   ] && LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
export LD_LIBRARY_PATH

export SHELL=$(which zsh)     # set the shell enviornment
export ARCH=$(uname)          # get the architecture to determine environment
export host=${HOST%%.*}       # short host name up to first dot foo.loc = foo
export EDITOR=vim             # set default editor to vim
export VISUAL=vim             # set default editor to vim
export WINEDITOR=gvim         # graphical editor when available
export CC=$(which gcc)        # use gcc as our compiler
export LC_ALL=C               # fix utf-8 garbled output for gcc
export LANG=C                 # fix utf-8 garbled output for gcc
export PAGER=less             # use less as the default pager
export LESS='-M -W'           # detailed status bar and highlight last read
set -a                        # automatically export EVERYTHING

if [ -z ${DISPLAY:=""} ]; then
    XSERVER=$(who -m | awk '{print $NF}' | tr -d ')''(' )
    if [[ -z ${XSERVER} || ${XSERVER} == $(hostname) ]]; then
        export DISPLAY=":0.0"          # display on local host
    else
        export DISPLAY=${XSERVER}:0.0  # display on remote host
    fi
    echo "Environment variable DISPLAY is $DISPLAY"
fi

# MISC SHELL OPTIONS
umask 022                   # default umask rwxr--r--
setopt NO_BEEP              # disable console beeps
setopt NO_CLOBBER           # prevent overwrite of files with redirect
setopt AUTO_CD              # cd to a directory by typing just it's name
setopt CORRECT_ALL          # try to automatically correct all mistakes
setopt EXTENDED_GLOB        # enable zsh's extended glob abilities
setopt PROMPT_SUBST         # enable prompt substution capabilities
setopt IGNORE_EOF           # don't exit if <Ctrl-d> is pressed
setopt CHASE_LINKS          # resolve symbolic links to their true values
watch=(notme)               # report other users logging on/off
WATCHFMT="[%T] %n has %a %l from %M"
autoload -Uz zmv            # load zsh move, a powerful file renaming tool
zmodload -i zsh/datetime    # necessary for $EPOCHSECONDS, the UNIX time

# HISTORY SETTINGS
export SAVEHIST=2048           # history file to save the last N commands
export HISTSIZE=4096           # history file size to N number of commands
export HISTFILE=~/.zsh/history # store the history file in this location
setopt SHARE_HISTORY           # share history between open terminal windows
setopt HIST_EXPIRE_DUPS_FIRST  # remove duplicates first
setopt INC_APPEND_HISTORY      # share as soon as possible between shells
setopt HIST_IGNORE_ALL_DUPS    # ignore all duplicate commands and add newer
setopt EXTENDED_HISTORY        # more information in history like runtime
setopt HIST_REDUCE_BLANKS      # remove superfluous blanks from each command

# KEY BINDINGS
bindkey "^?" backward-delete-char      # fix the behavior of backspace
bindkey "^[[3~" delete-char            # fix the delete key
bindkey "^[[A" history-search-backward # up arrow to search history backward
bindkey "^[[B" history-search-forward  # down arrow to search history forward
bindkey "\C-b" backward-word           # ctrl-b move cursor back one word
bindkey "\C-f" forward-word            # ctrl-f move cursor forward one word
bindkey "^x^x" exchange-point-and-mark # ctrl-x toggle beginning/end of line

# COMPLETION SETTINGS
ZSH_DIR=$HOME/.zsh
test ! -d $ZSH_DIR && mkdir -p $ZSH_DIR
if [[ ${fpath[(r)$HOME/.zsh/completion]} != $HOME/.zsh/completion ]]; then
    fpath=($HOME/.zsh/completion $fpath) # add custom completions to fpath
fi
ZSH_CACHE=$HOME/.zsh/zcompdump_$ZSH_VERSION
zmodload -i zsh/complist
autoload -U compinit && compinit -C -d $ZSH_CACHE
# Compile the cache if necessary to help speed up completions
if [ "$ZSH_CACHE" -nt "$ZSH_CACHE.zwc" -o ! -e "$ZSH_CACHE.zwc" ]; then
    zcompile "$ZSH_CACHE"
fi
setopt COMPLETE_IN_WORD     # complete from both ends of a word
setopt ALWAYS_TO_END        # move cursor to the end of a completed word
setopt PATH_DIRS            # perform path search on commands with slashes
setopt AUTO_MENU            # show completion menu on a successive tab press
setopt AUTO_LIST            # auto list choices on ambiguous completion
setopt AUTO_PARAM_SLASH     # if param is a directory, add a trailing slash
#setopt COMPLETE_ALIASES     # completion of command line switches for aliases
unsetopt MENU_COMPLETE      # do not auto select the first completion entry
unsetopt FLOW_CONTROL       # disable start/stop characters in shell editor
# use caching to make completion for commands such as dpkg and apt usable
zstyle ':completion::complete:*' use-cache on
# case-insensitive (all), partial-word, and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# group matches and describe
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %B-- %d (errors: %e) --%b'
zstyle ':completion:*:descriptions' format ' %B-- %d --%b'
zstyle ':completion:*:messages' format ' %B-- %U%d%u --%b'
zstyle ':completion:*:warnings' format ' %B-- no matches found --%b'
zstyle ':completion:*:default' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
# fuzzy match mistyped completions
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
# increase the number of errors based on the length of the typed word.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
# don't complete unavailable commands
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
# array completion element sorting
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
# directories
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true
# history
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes
# environmental variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}
# populate hostname completion
zstyle -e ':completion:*:hosts' hosts 'reply=(
${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//,/ }
${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'
# ignore multiple entries
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes
zstyle ':completion:*:rm:*' file-patterns '*:all-files'
# kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm'
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single
# man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true
# media
zstyle ':completion:*:*:mplayer:*' file-patterns '*.(wav|WAV|mp3|MP3|ogg|OGG|flac):ogg\ files *(-/):directories'
# ssh and remote host completion
zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order hosts-host hosts-domain hosts-ipaddr users files all-files
zstyle ':completion:*:(ssh|telnet|rlogin):*' tag-order 'hosts:-host hosts:-domain:domain hosts:-ipaddr:ip\ address *' users
zstyle ':completion:*:(ssh|telnet|rlogin):*' group-order hosts-host hosts-domain hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync|telnet|rlogin):*:hosts-host' ignored-patterns '*.*' loopback localhost
zstyle ':completion:*:(ssh|scp|rsync|telnet|rlogin):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^*.*' '*@*'
zstyle ':completion:*:(ssh|scp|rsync|telnet|rlogin):*:hosts-ipaddr' ignored-patterns '^<->.<->.<->.<->' '127.0.0.<->'
# keep prefixes unexpanded if possible
zstyle ':completion:*:expand:*' keep-prefix yes
# /u/s/d/r/README<Tab> lists all matching READMEs
zstyle ':completion:*' list-suffixes yes
# things to ignore from completion
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:(cd|mv|cp):*' ignore-parents parent pwd
zstyle ':completion:*:all-files' ignore-line other
zstyle ':completion:*:(mv|cp):all-files' ignore-line no
zstyle ':completion:*:*:-command-:*' ignored-patterns './config.*'

# ALIASES AND FUNCTIONS
alias h='history 1 -1'                 # shortcut for full history
alias rm='rm -i'                       # ask for confirmation on file deletion
alias mkdir='mkdir -p'                 # create path structure with mkdir
alias del='\rm -rf'                    # MS-DOS style unsafe file removal
alias cls='clear'                      # MS-DOS style terminal clear lines
alias -- .='pwd'                       # shows current working directory
alias -- ..='cd .. ; pwd'              # goes back one directory
function ../() { cd ../; pwd; }        # goes back one directory
alias -- ...='cd ../..; pwd'           # goes back two directories
function .../() { cd ../..; pwd; }     # goes back two directories
alias -- -='cd -'                      # goes to the previous directory
function /() { cd /; pwd; }            # goes to the root directory
alias du='du -h'                       # du human readable byte size
alias df='df -h'                       # df human readable byte size
alias ping='ping -c 5'                 # ping just does 5 packets
alias dir='ls -lah'                    # list files MS-DOS style
alias ll='ls -l'                       # long file list <dir> style
alias lx='ls -lXB'                     # sort by extension
alias lk='ls -lSr'                     # sort by size, biggest last
alias lc='ls -ltcr'                    # sort by change time, recent last
alias lu='ls -ltur'                    # sort by access time, recent last
alias lt='ls -ltr'                     # sort by date, most recent last
alias lm='\ls -al | more'              # pipe through 'more'
alias lr='ls -lR'                      # recursive ls
alias li='ls -ai'                      # list by index-node
alias lh='ls -lah'                     # list files human readable size
alias j='jobs -l'                      # list jobs
alias e='$EDITOR'                      # open our preferred editor
alias gv='gvim'
alias edit='gvim'
alias gvd='gvimdiff -geometry 160x50'
alias ctags='ctags -R --c++-kinds=+p --fields=+iaS --extra=+q'
alias ls='ls -a --color'               # GNU colorized ls
alias rm='rm -v -i'                    # verbose file deletion
alias cp='cp -v -i'                    # verbose file copy
alias mv='mv -v -i'                    # verbose file move
alias del='\rm -rf -v'                 # MS-DOS style unsafe file removal

# utility functions to find files by pattern match, remove by index-node,
# compress directories to various tape archive formats, grab strings, and
# convert to and from various parameter formats
function setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }
function ff() { find . -type f -name '*'$*'*'; }
function fd() { find . -type d -name '*'$*'*'; }
#function rgrep() { find . -name "*.cpp" -o -name "*.h" |xargs grep -n "$*"; }
function rgrep() { find . -type f -print |xargs grep -i -n "$*"; }
function rminode() { find . -inum "$*" -exec rm -i "{}" +; }
function gcompress() { tar cvf - "$*" | gzip -8cvv > "$*".tar.gz ; }
function bcompress() { tar cvf - "$*" | bzip2 -9cvv > "$*".tar.bz2 ; }
function lcompress() { tar cvf - "$*" | xz -5cvv > "$*".tar.xz ; }
function getcolumn() { perl -ne '@cols = split; print "$cols['$1']\n"' ; }
function showlines() { perl -pe 's/^/$. /' "$@" ; }
function showstrings() { cat "$1" | tr -d "\0" | strings ; }
function hex2dec() { echo $((0x$1)) ; }
function dec2hex() { printf "%x\n" $1 ; }
function milli2sec() { echo "scale=3; $1 / 1000" | bc; };
function sec2milli() { echo "scale=3; $1 * 1000" | bc; };
function micro2sec() { echo "scale=6; $1 / 1000000" | bc; };
function sec2micro() { echo "scale=6; $1 * 1000000" | bc; };
function nano2sec()  { echo "scale=9; $1 / 1000000000" | bc; };
function sec2nano()  { echo "scale=9; $1 * 1000000000" | bc; };

alias zapdirs='find . -depth -type d -exec rmdir "{}" \;'
alias allmd5='find . -type f -exec md5sum "{}" \;'
alias cdiso='sudo dd if=/dev/cdrom of=image.iso bs=2048 conv=sync,notrunc'
alias xlb='xload -bg LightSteelBlue -fg RoyalBlue -hl blue -scale 4 -geometry 160x90 &'
alias xlt='xload -bg BurlyWood3 -fg Chocolate4 -hl blue -scale 4 -geometry 160x90 &'
alias xlp='xload -bg Thistle2 -fg Orchid4 -hl blue -scale 4 -geometry 160x90 &'
alias xlg='xload -bg HoneyDew3 -fg DarkSeaGreen4 -hl blue -scale 4 -geometry 160x90 &'
alias xterm-dark='xterm -bg #1C293E -fg #5C76A3 &'
alias sudothat='eval "sudo $(fc -ln -1)"'
alias gitup='git pull'
alias gitci='git commit -a -m'
alias gitco='git checkout'
alias perl10='/usr/local/perl-5.10.1/bin/perl'

if [ -e `which less` ]; then
    alias more='less'                  # 'less is more' if we have it
fi
if [ -e `which vim` ]; then
    alias vi='vim'                     # use vim if we have it
fi
if [ -e `which enscript` ]; then       # pretty print to postscript file
    alias pjet='enscript -o output.ps -DDuplex:true -DTumble:true -r -M A4 -2'
    alias clpr='enscript -r -j -f Times-Roman8 --mark-wrapped-lines=box -2 -T 3'
fi

# FUNCTIONS
function extract()                     # extract some common archive types
{
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   bunzip2  < "$1" | tar xvf - ;;
            *.tar.gz)    gunzip   < "$1" | tar xvf - ;;
            *.tar.xz)    unxz     < "$1" | tar xvf - ;;
            *.bz2)       bunzip2    "$1"             ;;
            *.rar)       unrar x    "$1"             ;;
            *.gz)        gunzip     "$1"             ;;
            *.xz)        unxz       "$1"             ;;
            *.tar)       tar xvf    "$1"             ;;
            *.tbz2)      bunzip2  < "$1" | tar xvf - ;;
            *.tgz)       gunzip   < "$1" | tar xvf - ;;
            *.txz)       unxz     < "$1" | tar xvf - ;;
            *.zip)       unzip      "$1"             ;;
            *.Z)         uncompress "$1"             ;;
            *.7z)        7z x       "$1"             ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' file not found" >&2
    fi
}

function sendkey()                     # send public key to remote server
{
    if [ "$#" -eq 1 ]; then            # usage: sendkey <user@remotehost>
        local key=""
        if [ -f $HOME/.ssh/id_dsa.pub ]; then
            key=$HOME/.ssh/id_dsa.pub
        elif [ -f $HOME/.ssh/id_rsa.pub ]; then
            key=$HOME/.ssh/id_rsa.pub
        else
            echo "No public key found" >&2
            return 1
        fi
        ssh $1 'cat >> $HOME/.ssh/authorized_keys' < $key
    fi
}

function title()                       # sets terminal title bar text
{
    case $TERM in
        screen)
            print -nR $'\033k'$1$'\033'\\
            print -nR $'\033]0;'$2$'\a'
            ;;
        *xterm*|(ux|x)rvt|(dt|a|k|E)term)
            print -nR $'\033]0;'$*$'\a'
            ;;
        vt[24]20*)
            print -nR $'\033]0;'$*$'\007\033\\a'
            ;;
        sun*)
            print -nR $'\033]l'$*$'\033\\a'
            ;;
    esac
}

function icon()                        # sets terminal icon (minimized) text
{
    case $TERM in
        *xterm*|(ux|x)rvt|(dt|a|k|E)term)
            print -nR $'\033]1;'$*$'\007\a'
            ;;
        vt[24]20*)
            print -nR ""
            ;;
        sun*)
            print -nR $'\033]L'$*$'\033\\a'
            ;;
    esac
}

function precmd()                      # set the prompt, title bar, and icon
{
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))

    if [[ -n ${CLEARCASE_ROOT} ]]; then
        CC_VIEW="${CLEARCASE_ROOT##/*/}"
    else
        CC_VIEW=$(date '+%a %h %d %T')
    fi

    ###
    # Truncate the path if it's too long.

    PR_FILLBAR=""
    PR_PWDLEN=""
    PR_HBAR=" "

    local promptsize=${#${(%):-%n@%m-[$CC_VIEW]}}
    local pwdsize=${#${(%):-%d}}

    if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
        ((PR_PWDLEN=$TERMWIDTH - $promptsize))
    else
        PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${PR_HBAR}.)}"
    fi

    setprompt
    title "$PWD - zsh - ${COLUMNS}x${LINES}"
    icon "$host"
}

function preexec()                     # put the current command in title bar
{
    emulate -L zsh
    local -a cmd; cmd=(${(z)2})
    title $cmd[1]:t "$cmd[2,-1]"
    icon "$host"
}

# PROMPT SETTINGS
function setprompt()                   # dynamically configure the prompt
{
    case $TERM in
        *xterm*|(ux|x)rvt|(a|k|E)term)
            PROMPT=$'%{\e[1;32;40m%}%n%{\e[;40m%}@%{\e[1;34;40m%}%m%{\e[;40m%}%{\e[1;35;40m%}$PR_HBAR%$PR_PWDLEN<...<%d%<<${(e)PR_FILLBAR}$PR_HBAR%{\e[;40m%}%{\e[1;32;40m%}[${CC_VIEW}]\n%{\e[0m%}%# '
            ;;
        *)
            PROMPT=$'%B%n%b@%U%m%u$PR_HBAR%S%$PR_PWDLEN<...<%d%<<${(e)PR_FILLBAR}%s$PR_HBAR[${CC_VIEW}]\n%# '
            ;;
    esac
}

# colors for standard files and executables etc.
LS_COLORS="no=00:fi=00:di=01;34:ln=1;36;100:pi=40;33:so=01;35"
LS_COLORS=${LS_COLORS}:"bd=40;33;01:cd=40;33;01:or=40;31;01"
LS_COLORS=${LS_COLORS}:"mi=01;35:ex=01;32;40"
# archive and compressed file types are bold red
LS_COLORS=${LS_COLORS}:"*.tar=1;31:*.gz=1;31:*.xz=1;31:*.tbz2=1;31"
LS_COLORS=${LS_COLORS}:"*.tgz=1;31:*.arj=1;31:*.lzh=1;31:*.zip=1;31"
LS_COLORS=${LS_COLORS}:"*.z=1;31:*.Z=1;31:*.bz2=1;31:*.rpm=1;31"
LS_COLORS=${LS_COLORS}:"*.sit=1;31:*.sitx=1;31:*.jar=1;31:*.sea=1;31"
LS_COLORS=${LS_COLORS}:"*.deb=1;31:*.rar=1;31:*.zoo=1;31:*.uu=1;31"
LS_COLORS=${LS_COLORS}:"*.uue=1;31:*.yenc=1;31:*.hqx=1;31:*.lha=1;31"
LS_COLORS=${LS_COLORS}:"*.cab=1;31:*.7z=1;31:*.arc=1;31:*.txz=1;31"
# image file types are bold yellow with a black background
LS_COLORS=${LS_COLORS}:"*.jpg=1;33;40:*.jpeg=1;33;40:*.png=1;33;40"
LS_COLORS=${LS_COLORS}:"*.gif=1;33;40:*.bmp=1;33;40:*.tif=1;33;40"
LS_COLORS=${LS_COLORS}:"*.tiff=1;33;40:*.psd=1;33;40:*.pdd=1;33;40"
LS_COLORS=${LS_COLORS}:"*.eps=1;33;40:*.tga=1;33;40:*.pgm=1;33;40"
LS_COLORS=${LS_COLORS}:"*.psp=1;33;40:*.pic=1;33;40:*.ps2=1;33;40"
LS_COLORS=${LS_COLORS}:"*.dcs=1;33;40:*.iff=1;33;40:*.pct=1;33;40"
LS_COLORS=${LS_COLORS}:"*.pcx=1;33;40:*.pxr=1;33;40:*.sct=1;33;40"
LS_COLORS=${LS_COLORS}:"*.stn=1;33;40:*.xbm=1;33;40:*.xpm=1;33;40"
# audio and video file types are bold purple
LS_COLORS=${LS_COLORS}:"*.vob=1;35:*.ts=1;35:*.dvb=1;35:*.mpg=1;35"
LS_COLORS=${LS_COLORS}:"*.mpeg=1;35:*.mp2=1;35:*.avi=1;35:*.mov=1;35"
LS_COLORS=${LS_COLORS}:"*.qt=1;35:*.divx=1;35:*.asf=1;35:*.wmv=1;35"
LS_COLORS=${LS_COLORS}:"*.wm=1;35:*.wma=1;35:*.cda=1;35:*.ogg=1;35:"
LS_COLORS=${LS_COLORS}:"*.mp3=1;35:*.m4a=1;35:*.m4p=1;35:*.mp4=1;35"
LS_COLORS=${LS_COLORS}:"*.wav=1;35:*.au=1;35:*.mid=1;35:*.midi=1;35"
LS_COLORS=${LS_COLORS}:"*.aif=1;35:*.aiff=1;35:*.ra=1;35:*.ram=1;35"
LS_COLORS=${LS_COLORS}:"*.rm=1;35:*.rv=1;35:*.aac=1;35:*.rmi=1;35"
LS_COLORS=${LS_COLORS}:"*.ac3=1;35:*.h264=1;35:*.avs=1;35:*.mkv=1;35"
LS_COLORS=${LS_COLORS}:"*.mka=1;35:*.xvid=1;35:*.flv=1;35:*.flac=1;35"
LS_COLORS=${LS_COLORS}:"*.mpc=1;35:*.mp1=1;35:*.oga=1;35:*.m4r=1;35"
LS_COLORS=${LS_COLORS}:"*.3gp=1;35:*.wv=1;35:*.mpp=1;35:*.snd=1;35"
LS_COLORS=${LS_COLORS}:"*.ap3=1;35:*.apl=1;35:*.shn=1;35:*.ogv=1;35"
LS_COLORS=${LS_COLORS}:"*.ifo=1;35:*.bup=1;35:*.ogm=1;35:*.cdca=1;35"
export LS_COLORS

# Installation prefix (i.e. ./configure --prefix=$PREFIX etc.)
#export PREFIX=$HOME/usr/$ARCH
# Set the LDFLAGS for gcc/g++ local library files by architecture
#export LDFLAGS="-L$PREFIX/lib -R$PREFIX/lib"
# pkg-config libdir and path
#export PKG_CONFIG=$PREFIX/bin/pkg-config
#export PKG_CONFIG_LIBDIR=$PREFIX/lib
#export PKG_CONFIG_PATH=$PKG_CONFIG_LIBDIR/pkgconfig
#export C_INCLUDE_PATH=$PREFIX/include
#export CPLUS_INCLUDE_PATH=$C_INCLUDE_PATH

