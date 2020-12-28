#!/usr/bin/env bash
SET_UP_BASE="$HOME/.setup"
SETUP_CONFIG="$HOME/.setuprc"

# ensure setup folder and config file exists
[ -d "$SET_UP_BASE" ] || exit
[ -f "$SETUP_CONFIG" ] || exit

# Test themes
while IFS= read -r -d '' file; do
    theme="$(basename "$file")"
    if [ "$theme" != "themes" ]; then
        echo "Current theme: $theme"
        case $OSTYPE in
        darwin*)
            sed -i '' "s/^SET_UP_THEME=.*$/SET_UP_THEME='$theme'/g" "$SETUP_CONFIG"
            source "$HOME/.bash_profile"
            ;;
        *)
            sed -i "s/^SET_UP_THEME=.*$/SET_UP_THEME='$theme'/g" "$SETUP_CONFIG"
            source "$HOME/.bashrc"
            ;;
        esac
    fi
done < <(find "$SET_UP_BASE/themes/" -type d -print0 | sort -z)

case $OSTYPE in
darwin*)
    sed -i '' "s/^SET_UP_THEME=.*$/SET_UP_THEME='agnoster'/g" "$SETUP_CONFIG"
    ;;
*)
    sed -i "s/^SET_UP_THEME=.*$/SET_UP_THEME='agnoster'/g" "$SETUP_CONFIG"
    ;;
esac
