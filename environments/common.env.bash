#!/usr/bin/env bash
export EDITOR='vim'         # Make vim the default editor.
export LANG='en_US.UTF-8'   # Prefer US English and use UTF-8.
export LC_ALL='en_US.UTF-8' # Prefer US English and use UTF-8.

# TERM
if [[ $COLORTERM == gnome-* && $TERM == xterm ]] &&
  infocmp gnome-256color >/dev/null 2>&1; then
  export TERM='gnome-256color'
elif infocmp xterm-256color >/dev/null 2>&1; then
  export TERM='xterm-256color'
fi

# ls colors
if ls --color >/dev/null 2>&1; then # GNU
  export colorflag="--color"
  export LS_COLORS='no=00:fi=00:di=01;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:*.tar=36:*.tgz=36:*.arj=36:*.taz=36:*.lzh=36:*.zip=36:*.z=36:*.Z=36:*.gz=36:*.bz2=36:*.deb=36:*.rpm=36:*.jar=36:*.jpg=32:*.jpeg=32:*.gif=32:*.bmp=32:*.pbm=32:*.pgm=32:*.ppm=32:*.tga=32:*.xbm=32:*.xpm=32:*.tif=32:*.tiff=32:*.png=32:*.mov=32:*.mpg=32:*.mpeg=32:*.avi=32:*.fli=32:*.gl=32:*.dl=32:*.xcf=32:*.xwd=32:*.ogg=32:*.mp3=32:*.wav=32:'
else # macOS
  export colorflag="-G"
  export LSCOLORS='Gxfxcxdxbxegedabagacad'
fi
