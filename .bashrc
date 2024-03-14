# .bashrc
[[ "$-" != *i* ]] && return           # exit if not in interactive shell
if [ -f /etc/bashrc ]; then           # source global definitions if any
  . /etc/bashrc
fi
bind 'set bell-style none'            # no console beeping
export HISTCONTROL=ignoreboth:erasedups # ignore duplicate commands in history
export HISTSIZE=4096                  # history keep the last N entries
shopt -s histappend                   # append to history; don't overwrite
bind '"\e[A" history-search-backward' # up arrow to search history backward
bind '"\e[B" history-search-forward'  # down arrow to search history forward
bind '"\C-b" backward-word'           # ctrl-b move cursor back one word
bind '"\C-f" forward-word'            # ctrl-f move cursor forward one word
bind '"^x^x" exchange-point-and-mark' # ctrl-x toggle beginning/end of line
export PAGER=less                     # use less as the default pager
export XAUTHORITY=~/.Xauthority       # X Authority for ssh
export LESS='-R'                      # raw control chars ANSI color escape
# only add if the directory exists and is not already in PATH
function pathadd() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="${PATH:+"$PATH:"}$1"
  fi
}
pathadd /bin
pathadd /sbin
pathadd /usr/bin
pathadd /usr/sbin
pathadd /usr/local/bin
pathadd /usr/local/sbin
pathadd /opt/bin
pathadd /opt/bin64
pathadd ~/.local/bin
export PATH
# only add if the directory exists and is not already in LD_LIBRARY_PATH
function ldpathadd() {
  if [ -d "$1" ] && [[ ":$LD_LIBRARY_PATH:" != *":$1:"* ]]; then
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+"$LD_LIBRARY_PATH:"}$1"
  fi
}
ldpathadd /lib
ldpathadd /lib64
ldpathadd /usr/lib
ldpathadd /usr/lib64
ldpathadd /usr/local/lib
ldpathadd /usr/local/lib64
ldpathadd /opt/lib
ldpathadd /opt/lib64
export LD_LIBRARY_PATH
# more aliases and functions
alias h='history'                      # shortcut for history
alias rm='rm -i'                       # ask for confirmation on file deletion
alias mkdir='mkdir -p'                 # create path structure with mkdir
alias del='\rm -rf'                    # MS-DOS style unsafe file removal
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
alias ls='ls -a'                       # list all the files
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
alias tags='ctags -R --c++-kinds=+p --fields=+iaS --extra=+q'
alias rm='rm -v -i'                    # verbose file deletion
alias cp='cp -v -i'                    # verbose file copy
alias mv='mv -v -i'                    # verbose file move
alias del='\rm -rf -v'                 # MS-DOS style unsafe file removal
alias sudothat='eval "sudo $(fc -ln -1)"'  # sudo the last command
alias dist='lsb_release -a'            # get distribution info
alias zapdirs='find . -depth -type d -exec rmdir "{}" \;'
alias allmd5='find . -type f -exec md5sum "{}" \;'
alias cdiso='sudo dd if=/dev/cdrom of=image.iso bs=2048 conv=sync,notrunc'
function ff() { find . -type f -name '*'$*'*'; }
function fd() { find . -type d -name '*'$*'*'; }
function rgrep() { find . -type f -print | xargs grep -i -n "$*"; }
function rminode() { find . -inum "$*" -exec rm -i "{}" +; }
function gcompress() { tar cvf - "$*" | gzip -8cvv > "$*".tar.gz ; }
function bcompress() { tar cvf - "$*" | bzip2 -9cvv > "$*".tar.bz2 ; }
function lcompress() { tar cvf - "$*" | xz -5cvv > "$*".tar.xz ; }
function showstrings() { cat "$1" | tr -d "\0" | strings ; }
function hex2dec() { echo $((0x$1)) ; }
function dec2hex() { printf "%x\n" $1 ; }
function extract()            # extract some common archive types
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
      *.tbz)       bunzip2  < "$1" | tar xvf - ;;
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
function sendkey()             # send public key to remote server
{
  if [ "$#" -eq 1 ]; then      # usage: sendkey <user@remotehost>
    local key=""
    if [ -f $HOME/.ssh/id_ecdsa.pub ]; then
      key=$HOME/.ssh/id_ecdsa.pub
    elif [ -f $HOME/.ssh/id_rsa.pub ]; then
      key=$HOME/.ssh/id_rsa.pub
    else
      echo "No public key found" >&2
      return 1
    fi
    ssh $1 'cat >> $HOME/.ssh/authorized_keys' < $key
  fi
}
export TERM=xterm-256color    # set terminal type
# two line prompt that can auto-adjust to terminal width
C2=$'\001\033[1;34;40m\002'   # begin prompt bold cyan with black background
C0=$'\001\033[0;0m\002'       # end prompt normal
PS1='${C2}\[$(printf "%*s" $(($(tput cols)-22)) "") [\d \t]\r\u@\h \w \]${C0}\n\$ '
case "$(uname -sr)" in        # specific settings for certain OS
  Darwin*)                    # echo 'macOS'
    ;;
  Linux*Microsoft*)           # echo 'Windows Subsystem for Linux'
    ;;
  Linux*)                     # echo 'Linux'
    ;;
  CYGWIN*|MINGW*|MINGW32*|MSYS*) # echo 'Windows'
    export NO_AT_BRIDGE=1     # stop cygwin dbus errors
    ;;
esac
