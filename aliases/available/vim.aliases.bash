cite 'about-alias'
about-alias 'vim abbreviations'

VLESS=$(find /usr/share/vim -name 'less.sh')
if [ ! -z $VLESS ]; then
    alias vless=$VLESS
fi

VIM=$(command -v vim)
GVIM=$(command -v gvim)
MVIM=$(command -v mvim)

[[ -n $VIM ]] && alias v=$VIM

case $ostype in
  darwin*)
    [[ -n $MVIM ]] && alias mvim="mvim --remote-tab"
    ;;
  *)
    [[ -n $GVIM ]] && alias gvim="gvim -b --remote-tab"
    ;;
esac
