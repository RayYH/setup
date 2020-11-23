#!/usr/bin/env bash
# Merge PDF files, preserving hyperlinks, Usage: `mergepdf input{1,2,3}.pdf`
alias mergepdf='gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=_merged.pdf'
# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'
# Show IP addresses
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
# Show active network interfaces
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"
# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"
# current time
alias now="date '+%Y-%m-%d %H:%I:%S'"
# current timestamp
alias now_ts="date '+%s'"
# Checksum
command -v hd >/dev/null || alias hd="hexdump -C"             # hd
command -v md5sum >/dev/null || alias md5sum="md5"            # md5
command -v sha1sum >/dev/null || alias sha1sum="shasum"       # shasum
# Common Folder Navigation
alias ..="cd .."                                              # Go back 1 directory level (for fast typers)
alias cd..="cd .."                                            # Go back 1 directory level
alias ...="cd ../.."                                          # Go back 2 directory levels
alias .3='cd ../../../'                                       # Go back 3 directory levels
alias .4='cd ../../../../'                                    # Go back 4 directory levels
alias .5='cd ../../../../../'                                 # Go back 5 directory levels
alias .6='cd ../../../../../../'                              # Go back 6 directory levels
alias ~="cd ~"                                                # Go Home
alias -- -="cd -"                                             # Go back to previous folder
# Network Resources
alias GET="lwp-request -m 'GET'"                              # GET
alias HEAD="lwp-request -m 'HEAD'"                            # HEAD
alias POST="lwp-request -m 'POST'"                            # POST
alias PUT="lwp-request -m 'PUT'"                              # PUT
alias DELETE="lwp-request -m 'DELETE'"                        # DELETE
alias TRACE="lwp-request -m 'TRACE'"                          # TRACE
alias OPTIONS="lwp-request -m 'OPTIONS'"                      # OPTIONS
# Folder Navigation
alias e="cd ~/Code/env && clear"                              # Docker/Vagrant/Kubernetes
alias dl="cd ~/Downloads && clear"                            # Download
alias dt="cd ~/Desktop && clear"                              # Desktop
alias one="cd ~/OneDrive && clear"                            # OneDrive
alias p="cd ~/Code/projects && clear"                         # projects
alias pc="cd ~/Code/projects/c && clear"                      # C projects
alias pcpp="cd ~/Code/projects/cpp && clear"                  # CPP projects
alias pphp="cd ~/Code/projects/php && clear"                  # PHP projects
alias ppython="cd ~/Code/projects/python && clear"            # Python projects
alias pjava="cd ~/Code/projects/java && clear"                # Java projects
alias pjs="cd ~/Code/projects/javascript && clear"            # JavaScript projects
alias pshell="cd ~/Code/projects/shell && clear"              # Shell projects
alias pgo="cd ~/Code/projects/go && clear"                    # go projects
# Preferred Commands, colorflag see common.env.bash
alias cp='cp -iv'                                             # Preferred 'cp' implementation
alias mv='mv -iv'                                             # Preferred 'mv' implementation
alias mkdir='mkdir -p'                                        # Preferred 'mkdir' implementation
alias less='less -FSRXc'                                      # Preferred 'less' implementation
alias ls='command ls ${colorflag}'                            # colorful ls
alias l='ls -lF ${colorflag}'                                 # List all files colorized in long format
alias la='ls -lAF ${colorflag}'                               # List all files colorized in long format, excluding . and ..
alias lsd='ls -lF ${colorflag} | grep --color=never "^d"'     # List only directories
alias grep='grep --color=auto'                                # Always enable colored `grep` output
alias fgrep='fgrep --color=auto'                              # Always enable colored `fgrep` output
alias egrep='egrep --color=auto'                              # Always enable colored `egrep` output
alias python3="PYTHONPATH=. python3"                          # Always append current dir to PYTHONPATH when exec python scripts
alias pdflatex='pdflatex -shell-escape'                       # Preferred 'pdflatex' implementation
# Commands
alias editHosts='sudo vim /etc/hosts'                         # Edit /etc/hosts file
alias qfind="find . -name "                                   # Quickly search for file
alias sudo='sudo '                                            # Enable aliases to be sudo’ed
alias week='date +%V'                                         # Get week number
alias c="tr -d '\n' | pbcopy"                                 # Trim new lines and copy to clipboard: `cat filename | c`
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete" # Delete all .DS_Store files recursively
alias path='echo -e ${PATH//:/\\n}'                           # Print all paths
alias reload='exec ${SHELL} -l'                               # Reload shell
alias map="xargs -n1"                                         # Intuitive map function, For example, to list all directories that contain a certain file: `find . -name .gitattributes | map dirname`
# Network Commands
alias ip="dig +short myip.opendns.com @resolver1.opendns.com" # ip:           Public real IP
alias myip='curl https://api.myip.com'                        # myip:         Public Proxied IP
alias netCons='lsof -i'                                       # netCons:      Show all TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'                      # flushDNS:     clear DNS cache
alias lsock='sudo /usr/sbin/lsof -i -P'                       # lsock:        show opened sockets
alias lsockU='sudo /usr/sbin/lsof -i -n -P | grep UDP'        # lsockU:       show opened UDP sockets
alias lsockT='sudo /usr/sbin/lsof -i -n -P | grep TCP'        # lsockT:       show opened TCP sockets
alias localip="ipconfig getifaddr en0"                        # localip:      show local ip
alias ipInfo0='ipconfig getpacket en0'                        # ipInfo0:      en0 info
alias ipInfo1='ipconfig getpacket en1'                        # ipInfo1:      en1 info
alias openPorts='sudo lsof -i | grep LISTEN'                  # openPorts:    show sockets with LISTEN state
