#!/bin/bash

what="${1}" ; shift
text="$*"

if [ "${what}" = "-h" ]; then
   echo "settitle.sh [ both | tab | title ] text"
   echo "  used to set iterm window or tab title"
   echo
   exit 0
fi

# Source - https://superuser.com/a/344397
# Posted by Orangenhain
# Retrieved 2026-10-16, License - CC BY-SA 3.0

# $1 = type; 0 - both, 1 - tab, 2 - title
# rest = text
setTerminalText () {
    # echo works in bash & zsh
    local mode=$1 ; shift
    echo -ne "\033]$mode;$@\007"
}
stt_both  () { setTerminalText 0 "$@"; }
stt_tab   () { setTerminalText 1 "$@"; }
stt_title () { setTerminalText 2 "$@"; }

case "${what}" in
  "both")
    stt_both "${text}"
    ;;
  "tab")
    stt_tab "${text}"
    ;;
  "title")
    stt_title "${text}"
    ;;
  *)
    echo "ERROR: invalid option ${what}"
    exit 1
esac
exit 0

