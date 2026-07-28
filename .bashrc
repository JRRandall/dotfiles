# Exit if not interactive
[[ $- != *i* ]] && return

# Source global
[[ -f /etc/bashrc ]] && . /etc/bashrc

# ----- Locale/time -----
export TZ="America/New_York"

# ----- Readline tweaks -----
bind 'set bell-style none'
bind '"\e[A" history-search-backward' # up arrow to search history backward
bind '"\e[B" history-search-forward'  # down arrow to search history forward
bind '"\C-b" backward-word'           # ctrl-b move cursor back one word
bind '"\C-f" forward-word'            # ctrl-f move cursor forward one word
bind '"\C-x\C-x": exchange-point-and-mark' # ctrl-x toggle beginning/end line

# ----- History -----
shopt -s histappend
unset HISTTIMEFORMAT
export HISTCONTROL=ignorespace:erasedups
export HISTSIZE=4096
export HISTFILESIZE=20000
export PROMPT_COMMAND='history -a'

# ----- Useful shell opts -----
shopt -s checkwinsize autocd cdspell

# ----- Defaults -----
umask 002                             # permissions so group members can write
export PAGER=less                     # use less as the default pager
export XAUTHORITY=~/.Xauthority       # X Authority for ssh
export LESS='-R'                      # raw control chars ANSI color escape
export TERM=xterm-256color
export NO_AT_BRIDGE=1

# ----- Path -----
pathadd() {
  local d="$1"
  [[ -d $d ]] && [[ :$PATH: != *:"$d":* ]] && PATH="${PATH:+$PATH:}$d"
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

# ----- Aliases -----
alias h='history'                      # shortcut for history
alias mkdir='mkdir -p'                 # create path structure with mkdir
alias del='\rm -rf'                    # MS-DOS style unsafe file removal
alias -- ..='cd .. ; pwd'              # goes back one directory
function ../() { cd ../; pwd; }        # goes back one directory
alias -- ...='cd ../..; pwd'           # goes back two directories
function .../() { cd ../..; pwd; }     # goes back two directories
alias -- -='cd -'                      # goes to the previous directory
function /() { cd /; pwd; }            # goes to the root directory
alias du='du -h'                       # du human readable byte size
alias df='df -h'                       # df human readable byte size
alias ls='ls -a'                       # list all the files
alias ll='ls -l'                       # long file list <dir> style
alias dir='ls -d -- */ .*/ 2>/dev/null' # list all directories (folders) only
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
alias cp='cp -v -i'                    # verbose file copy
alias mv='mv -v -i'                    # verbose file move
alias del='\rm -rf -v'                 # MS-DOS style unsafe file removal
alias sudothat='eval "sudo $(fc -ln -1)"'  # sudo the last command
alias dist='lsb_release -a'            # get distribution info
alias zapdirs='find . -depth -type d -exec rmdir "{}" \;'
alias allmd5='find . -type f -exec md5sum "{}" \;'
alias cdiso='sudo dd if=/dev/cdrom of=image.iso bs=2048 conv=sync,notrunc'
alias web='firefox -CreateProfile "$(hostname)" ; firefox -P "$(hostname)" &'
alias nx='sudo /etc/NX/nxserver --list'
alias gl='git log --oneline --decorate --graph -20'

# ----- Functions (null/space safe) -----
function which() { type -a "$@" ; } # old habits die hard (could also use command -V)
function ff() { find . -type f -name '*'$*'*' -print 2>/dev/null ; }
function fd() { find . -type d -name '*'$*'*' -print 2>/dev/null ; }
function rgrep() { find . -type f -print 2>/dev/null | xargs grep -s -i -n "$*"; }
function rminode() { find . -inum "$*" -exec rm -i "{}" +; }
function gcompress() { tar cvf - "$*" | gzip -8cvv > "$*".tar.gz ; }
function bcompress() { tar cvf - "$*" | bzip2 -9cvv > "$*".tar.bz2 ; }
function lcompress() { tar cvf - "$*" | xz -5cvv > "$*".tar.xz ; }
function zcompress() { zip -9rv "$*".zip "$*" ; }
function 7compress() { 7z a -bb1 "$*".7z "$*" ; }
function showstrings() { cat "$1" | tr -d "\0" | strings ; }
function hex2dec() { echo $((0x$1)) ; }
function dec2hex() { printf "%x\n" $1 ; }

function extract() {    # extract some common archive types
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
      *.xsa)       unzip      "$1"             ;; # PL images
      *.hdf)       unzip      "$1"             ;; # PL images
      *.Z)         uncompress "$1"             ;;
      *.7z)        7z x       "$1"             ;;
      *)           echo "'$1' cannot be extracted via >extract<" ;;
    esac
  else
    echo "'$1' file not found" >&2
  fi
}

function sendkey() {    # send public key to remote server
  [[ $# -eq 1 ]] || { echo "Usage: sendkey user@host" >&2; return 2; }
  local key=
  if   [[ -f $HOME/.ssh/id_ed25519.pub ]]; then key=$HOME/.ssh/id_ed25519.pub
  elif [[ -f $HOME/.ssh/id_ecdsa.pub ]]; then key=$HOME/.ssh/id_ecdsa.pub
  elif [[ -f $HOME/.ssh/id_rsa.pub   ]]; then key=$HOME/.ssh/id_rsa.pub
  else echo "No public key found" >&2; return 1; fi
  ssh "$1" 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' < "$key"
}

# ----- Prompt (two-line) -----
C1=$'\001\033[0;37;40m\002'
C0=$'\001\033[0;0m\002'
PS1='${C1}\[$(printf "%*s" $(($(tput cols)-9)) "") \t\r\u@\h \w \]${C0}\n\$ '

# ----- History maintenance -----
compact-history() {
  local histfile="${HISTFILE:-$HOME/.bash_history}"
  local tmpfile; tmpfile=$(mktemp)
  history -a
  if command -v tac >/dev/null 2>&1; then
    tac "$histfile" | awk '!seen[$0]++' | tac > "$tmpfile"
  else
    # portable tac using awk
    awk ' { line[NR]=$0 } END { for (i=NR;i>=1;i--) if (!seen[line[i]]++) print line[i] } ' "$histfile" > "$tmpfile"
    # then reverse again
    awk ' { line[NR]=$0 } END { for (i=NR;i>=1;i--) print line[i] } ' "$tmpfile" > "${tmpfile}.rev"
    \mv "${tmpfile}.rev" "$tmpfile"
  fi
  \mv "$tmpfile" "$histfile"
  history -c
  history -r
  echo "History compacted."
}
