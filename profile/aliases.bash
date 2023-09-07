#!/usr/bin/env bash
# shellcheck disable=SC2139

#===========================================================================#
#                         Folder Navigation                                 #
#===========================================================================#
alias ..="cd .."                                              # go back 1 directory level
alias cd..="cd .."                                            # go back 1 directory level
alias ...="cd ../.."                                          # go back 2 directory levels
alias .3='cd ../../../'                                       # go back 3 directory levels
alias .4='cd ../../../../'                                    # go back 4 directory levels
alias .5='cd ../../../../../'                                 # go back 5 directory levels
alias .6='cd ../../../../../../'                              # go back 6 directory levels
alias ~="cd ~"                                                # go Home
alias -- -="cd -"                                             # go back to previous folder
alias dl="cd ~/Downloads && clear"                            # Download
alias dt="cd ~/Desktop && clear"                              # Desktop
alias ic="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs" # icloud
alias tmp="cd ~/Temp"                                         # tmp folder

#===========================================================================#
#                         Networking Commands                               #
#===========================================================================#
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"                                                                                                  # public real IP
alias myip='curl https://api.myip.com'                                                                                                                         # public proxied IP
alias loip="ipconfig getifaddr en0"                                                                                                                            # show local ip
alias sockets='lsof -i'                                                                                                                                        # show all TCP/IP sockets
alias flushdns='dscacheutil -flushcache'                                                                                                                       # clear DNS cache
alias lsock='sudo /usr/sbin/lsof -i -P'                                                                                                                        # show opened sockets
alias lsocku='sudo /usr/sbin/lsof -i -n -P | grep UDP'                                                                                                         # show opened UDP sockets
alias lsockt='sudo /usr/sbin/lsof -i -n -P | grep TCP'                                                                                                         # show opened TCP sockets
alias openports='sudo lsof -i | grep LISTEN'                                                                                                                   # show sockets with LISTEN state
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'" # show ip addresses
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"                                                                              # Show active network interfaces

#===========================================================================#
#                        Networking Resources                               #
#===========================================================================#
alias GET="lwp-request -m 'GET'"         # GET
alias HEAD="lwp-request -m 'HEAD'"       # HEAD
alias POST="lwp-request -m 'POST'"       # POST
alias PUT="lwp-request -m 'PUT'"         # PUT
alias DELETE="lwp-request -m 'DELETE'"   # DELETE
alias TRACE="lwp-request -m 'TRACE'"     # TRACE
alias OPTIONS="lwp-request -m 'OPTIONS'" # OPTIONS

#===========================================================================#
#                           Apple Services                                  #
#===========================================================================#
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"                                                                                                                              # Flush Directory Service cache
alias clear_files="sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"                           # Clear Apple’s System Logs to improve shell startup speed, clear download history from quarantine.
alias ls_cleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder" # Clean up LaunchServices to remove duplicates in the “Open With” menu
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"                                                                                                      # Show hidden files in Finder
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"                                                                                                     # Hide hidden files in Finder
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"                                                                                                   # Show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"                                                                                                  # Hide all desktop icons (useful when presenting)
alias spotoff="sudo mdutil -a -i off"                                                                                                                                                            # Disable Spotlight
alias spoton="sudo mdutil -a -i on"                                                                                                                                                              # Enable Spotlight
alias say="say -v Alex "                                                                                                                                                                         # preferred say command

#===========================================================================#
#                             Date/Time                                     #
#===========================================================================#
alias now="date '+%Y-%m-%d %H:%I:%S'" # current time
alias now_ts="date '+%s'"             # current timestamp

#===========================================================================#
#                              Checksum                                     #
#===========================================================================#
command -v hd >/dev/null || alias hd="hexdump -C"       # hd
command -v md5sum >/dev/null || alias md5sum="md5"      # md5
command -v sha1sum >/dev/null || alias sha1sum="shasum" # shasum

#===========================================================================#
#                         Preferred Commands                                #
#===========================================================================#
# ls colors
if ls --color >/dev/null 2>&1; then # GNU
  export colorflag="--color"
  export LS_COLORS='no=00:fi=00:di=01;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:*.tar=36:*.tgz=36:*.arj=36:*.taz=36:*.lzh=36:*.zip=36:*.z=36:*.Z=36:*.gz=36:*.bz2=36:*.deb=36:*.rpm=36:*.jar=36:*.jpg=32:*.jpeg=32:*.gif=32:*.bmp=32:*.pbm=32:*.pgm=32:*.ppm=32:*.tga=32:*.xbm=32:*.xpm=32:*.tif=32:*.tiff=32:*.png=32:*.mov=32:*.mpg=32:*.mpeg=32:*.avi=32:*.fli=32:*.gl=32:*.dl=32:*.xcf=32:*.xwd=32:*.ogg=32:*.mp3=32:*.wav=32:'
else # macOS
  export colorflag="-G"
  export LSCOLORS='Gxfxcxdxbxegedabagacad'
fi
alias cp='cp -iv'                                         # Preferred 'cp' implementation
alias mv='mv -iv'                                         # Preferred 'mv' implementation
alias mkdir='mkdir -p'                                    # Preferred 'mkdir' implementation
alias less='less -FSRXc'                                  # Preferred 'less' implementation
alias ls='command ls ${colorflag}'                        # colorful ls
alias l='ls -lF ${colorflag}'                             # List all files colorized in long format
alias la='ls -lAF ${colorflag}'                           # List all files colorized in long format, excluding . and ..
alias lsd='ls -lF ${colorflag} | grep --color=never "^d"' # List only directories
alias l1='ls -1 ${colorflag}'                             # List one column
alias grep='grep --color=auto'                            # Always enable colored `grep` output
alias fgrep='fgrep --color=auto'                          # Always enable colored `fgrep` output
alias egrep='egrep --color=auto'                          # Always enable colored `egrep` output
alias ssh='TERM=xterm ssh'                                # Always use xterm
alias cheat='cheat -c'                                    # Always colorized

#===========================================================================#
#                      Other Commands or Aliases                            #
#===========================================================================#
alias qfind="find . -name "                                                         # Quickly search for file
alias sudo='sudo '                                                                  # Enable aliases to be sudo’ed
alias week='date +%V'                                                               # Get week number
alias co="tr -d '\n' | pbcopy"                                                      # Trim new lines and copy to clipboard: `cat filename | c`
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"                       # Delete all .DS_Store files recursively
alias path='echo -e ${PATH//:/\\n}'                                                 # Print all paths
alias reload="source ~/.bashrc"                                                     # reload bashrc
alias map="xargs -n1"                                                               # Intuitive map function, For example, to list all directories that contain a certain file: `find . -name .gitattributes | map dirname`
alias _="sudo"                                                                      # preferred sudo
alias vbrc="vim ~/.bashrc"                                                          # edit .bashrc file
alias vbpf="vim ~/.bash_profile"                                                    # edit .bash_profile file
alias editHosts='sudo vim /etc/hosts'                                               # edit hosts file
alias cls='clear'                                                                   # clear screen
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'       # open google chrome
alias mergepdf='gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=_merged.pdf' # Merge PDF files, preserving hyperlinks, Usage: `mergepdf input{1,2,3}.pdf`
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'                       # laravel sail
alias python3="PYTHONPATH=. python3"                                                # Always append current dir to PYTHONPATH when exec python scripts
alias pdflatex='pdflatex -shell-escape'                                             # Preferred 'pdflatex' implementation
alias qemu="qemu-system-x86_64"                                                     # qemu emulator
alias setuprc='${EDITOR:=vi} ${HOME}/.setuprc'                                      # Quick access to the .setuprc file
alias ee="echo -e"                                                                  # ee
alias g11='g++ -std=c++11 -O2 -Wall '                                               # g++
alias lzd='lazydocker'                                                              # lazydocker

if command -v thefuck &>/dev/null; then
  eval "$(thefuck --alias)"
fi

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init bash)"
fi

if ! command -v docker-compose &>/dev/null; then
  alias docker-compose="docker compose"
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if command -v xclip &>/dev/null; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
  fi
fi
