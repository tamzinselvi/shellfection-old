# {{{ Install Brew
printf "$Purple"
printf "$Divider"
nl
textwrap center "Checking for brew..."
nl
printf "$Divider"

if ! type brew > /dev/null 2>&1; then
  printf "$Yellow"
  nl
  textwrap center "brew not found, installing..."
  nl
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  let Success=Success+1
else
  printf "$Green"
  nl
  textwrap center "brew is already installed, continuing..."
  nl
  let NoChanges=NoChanges+1
fi
# }}}

# {{{ Install Brew Packages
for pkg in tmux reattach-to-user-namespace the_silver_searcher cmatrix vim zsh wget tig pandoc lynx bash python; do
  printf "$Purple"
  printf "$Divider"
  nl
  textwrap center "Checking for $pkg..."
  nl
  printf "$Divider"

  if ! brew list -1 | grep -q "${pkg}"; then
    printf "$Yellow"
    nl
    textwrap center "$pkg not found, installing..."
    nl
    brew install $pkg
    let Success=Success+1
  else
    printf "$Green"
    nl
    textwrap center "$pkg is already installed, continuing..."
    nl
    let NoChanges=NoChanges+1
  fi
done
# }}}

# {{{ Powerline Ubuntu Font
printf "$Purple"
printf "$Divider"
nl
textwrap center "Installing Powerline Ubuntu font..."
nl
printf "$Divider"
printf "$Color_Off"

if [ -a ~/Library/Fonts/Ubuntu\ Mono\ derivative\ Powerline.ttf ]; then
  printf "$Green"
  nl
  textwrap center "Font already installed, continuing..."
  nl
  let NoChanges=NoChanges+1
else
  printf "$Yellow"
  nl
  textwrap center "Font not found, installing..."
  nl
  wget https://github.com/powerline/fonts/raw/master/UbuntuMono/Ubuntu%20Mono%20derivative%20Powerline.ttf
  mv "Ubuntu Mono derivative Powerline.ttf" ~/Library/Fonts
  let Success=Success+1
fi
# }}}
