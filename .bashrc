# Exit if not interactive
[[ $- != *i* ]] && return

# Source global
[[ -f /etc/bashrc ]] && . /etc/bashrc

# ----- Locale/time -----
export TZ="America/New_York"

# ----- Readline tweaks -----
bind 'set bell-style none'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\C-b": backward-word'
bind '"\C-f": forward-word'
bind '"\C-x\C-x": exchange-point-and-mark'

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
umask 002
export PAGER=less
export LESS='-R -F -X -M -i'
export XAUTHORITY="$HOME/.Xauthority"
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
alias h='history'
alias mkdir='mkdir -p'
alias del='\rm -rf'
alias -- ..='cd ..; pwd'
alias -- ...='cd ../..; pwd'
alias -- -='cd -'
alias du='du -h'
alias df='df -h'
alias ls='ls -a'
alias ll='ls -l'
alias dir='ls -d -- */ .*/ 2>/dev/null'
alias lx='ls -lXB'
alias lk='ls -lSr'
alias lc='ls -ltcr'
alias lu='ls -ltur'
alias lt='ls -ltr'
alias lm='\ls -al | more'
alias lr='ls -lR'
alias li='ls -ai'
alias lh='ls -lah'
alias tags='ctags -R --c++-kinds=+p --fields=+iaS --extra=+q'
alias cp='cp -v -i'
alias mv='mv -v -i'
alias sudothat='eval "sudo $(fc -ln -1)"'
alias dist='lsb_release -a'
alias zapdirs='find . -depth -type d -exec rmdir "{}" \;'
alias allmd5='find . -type f -exec md5sum "{}" \;'
alias cdiso='sudo dd if=/dev/cdrom of=image.iso bs=2048 conv=sync,notrunc'
alias web='firefox -CreateProfile "$(hostname)"; firefox -P "$(hostname)" &'

# ----- Project jump aliases -----
alias omc='cd ~/Development/steed/zynq/boa'
alias ce='cd ~/Development/ce'
alias cmdtlm='cd ~/Development/cmdtlm'
alias c='cd ~/Development/como_fsw'
alias como_test='cd ~/Development/como_test'
alias bamboo='cd ~/Development/Bamboo'
alias wb='/opt/WindRiver7/workbench-4/startWorkbench.sh &'
alias nx='sudo /etc/NX/nxserver --list'

# ----- Functions (null/space safe) -----
ff() { find . -type f \( -iname "*${*}*" \) -print0 2>/dev/null | xargs -0 -I{} printf '%s\n' "{}"; }
fd() { find . -type d \( -iname "*${*}*" \) -print0 2>/dev/null | xargs -0 -I{} printf '%s\n' "{}"; }
rgrep() { find . -type f -print0 2>/dev/null | xargs -0 grep -sin "$@"; }
gcompress() { tar -cvf - -- "$@" | gzip  -8cvv > "$1".tar.gz; }
bcompress() { tar -cvf - -- "$@" | bzip2 -9cvv > "$1".tar.bz2; }
lcompress() { tar -cvf - -- "$@" | xz    -5cvv > "$1".tar.xz; }
zcompress() { zip -9rv "$1".zip -- "$@"; }
7compress() { 7z a -bb1 "$1".7z -- "$@"; }
showstrings() { tr -d '\0' < "$1" | strings; }
hex2dec() { printf '%d\n' "0x$1"; }
dec2hex() { printf '%x\n' "$1"; }

extract() {
  local f=$1
  [[ -f $f ]] || { echo "'$f' not found" >&2; return 1; }
  case "$f" in
    *.tar.bz2|*.tbz2|*.tbz)   bunzip2  <"$f" | tar xvf - ;;
    *.tar.gz|*.tgz)           gunzip   <"$f" | tar xvf - ;;
    *.tar.xz|*.txz)           unxz     <"$f" | tar xvf - ;;
    *.bz2)                    bunzip2   "$f" ;;
    *.rar)                    unrar x   "$f" ;;
    *.gz)                     gunzip    "$f" ;;
    *.xz)                     unxz      "$f" ;;
    *.tar)                    tar xvf   "$f" ;;
    *.zip|*.xsa|*.hdf)        unzip     "$f" ;;
    *.Z)                      uncompress "$f" ;;
    *.7z)                     7z x      "$f" ;;
    *)                        echo "'$f' cannot be extracted via extract" ;;
  esac
}

sendkey() {
  [[ $# -eq 1 ]] || { echo "Usage: sendkey user@host" >&2; return 2; }
  local key=
  if   [[ -f $HOME/.ssh/id_ecdsa.pub ]]; then key=$HOME/.ssh/id_ecdsa.pub
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
