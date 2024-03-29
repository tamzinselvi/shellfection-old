#!/bin/bash

Failed=0
Success=0
NoChanges=0

DividerWidth=$( tput cols )
let DividerWidthHalf=DividerWidth/2

Divider="$( eval "printf '*%.0s' {1..$DividerWidth}" )\n"

. ./scripts/colors.sh
. ./scripts/helpers.sh

# {{{ Warning Message
printf "$Red"
printf "$Divider"
nl
textwrap center "WARNING"
textwrap center "If you wish to proceed, be wary. This install has only been tested on Mac OS X El Capitan and some versions Ubuntu"
textwrap center "Do you wish to continue? [y/N]"
nl
printf "$Divider"
printf "$Color_Off"

while true; do
  eval "printf ' %.0s' {1..$DividerWidthHalf}"
  read -p "" yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    * ) textwrap center "Please answer yes or no.";;
  esac
done
# }}}

# {{{ Platform specific
if [ "$(uname)" == "Darwin" ]; then
  # Mac OS X
  . ./scripts/macosx.sh
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  # GNU/Linux
  . ./scripts/linux.sh
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
  # Windows
  echo ""
fi
# }}}

# {{{ Install custom executables
printf "$Purple"
printf "$Divider"
nl
textwrap center "Linking custom executables..."
nl
printf "$Divider"
nl

for file in pipeseroni-pipes shellfection-screensavers shellfection-welcome shellfection-cube shellfection-game-of-life shellfection-mpv-playlist; do
  sudo rm /usr/local/bin/$file
  sudo cp bin/$file /usr/local/bin/$file
  sudo chmod +x /usr/local/bin/$file
  printf "$Yellow"
  textwrap center "Linked $file to /usr/local/bin/$file"
done

printf "$Green"
nl
textwrap center "Finished linking..."
nl
# }}}

# {{{ Install PIP Packages
for pkg in pillow drawille; do
  printf "$Purple"
  printf "$Divider"
  nl
  textwrap center "Checking for $pkg..."
  nl
  printf "$Divider"

  if ! pip list 2>/dev/null | grep -iq $pkg; then
    printf "$Yellow"
    nl
    textwrap center "$pkg not found, installing..."
    nl
    sudo pip install $pkg
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

# {{{ Install asciiquarium
printf "$Purple"
printf "$Divider"
nl
textwrap center "Checking for asciiquarium..."
nl
printf "$Divider"

if ! type asciiquarium > /dev/null 2>&1; then
  printf "$Yellow"
  nl
  textwrap center "asciiquarium not found, installing..."
  nl
  wget http://www.robobunny.com/projects/asciiquarium/asciiquarium.tar.gz
  tar -zxvf asciiquarium.tar.gz
  cd asciiquarium_1.1/
  chmod +x asciiquarium
  sudo cp asciiquarium /usr/local/bin/asciiquarium
  sudo cpan Term::Animation
  cd ../
  rm -rf asciiquarium_1.1/ asciiquarium.tar.gz
  sudo cpan Term::Animation
  let Success=Success+1
else
  printf "$Green"
  nl
  textwrap center "brew is already installed, continuing..."
  nl
  let NoChanges=NoChanges+1
fi
# }}}

# {{{ Install Vundle
printf "$Purple"
printf "$Divider"
nl
textwrap center "Installing Vundle and Vundles..."
nl
printf "$Divider"

if [ -d ~/.config/nvim/bundle/Vundle.vim ]; then 
  printf "$Green"
  nl
  textwrap center "Vundle already installed, continuing..."
  nl
  let NoChanges=NoChanges+1
else
  printf "$Yellow"
  nl
  textwrap center "Vundle not found, installing..."
  nl
  mkdir -p ~/.config/nvim/bundle
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
  vim +PluginInstall +qall
  echo "colorscheme holokai" >> ~/.vimrc.local
  let Success=Success+1
fi
# }}}

# {{{ ZSH Default
if [ "$SHELL" != "$( which zsh )" ]; then
  printf "$Yellow"
  printf "$Divider"
  nl
  textwrap center "Would you like to use zsh by default? [y/N]"
  nl
  printf "$Divider"
  printf "$Color_Off"

  hash -r

  while true; do
    eval "printf ' %.0s' {1..$DividerWidthHalf}"
    read -p "" yn
    case $yn in
      [Yy]* )
        if ! grep -q "$( which zsh )" /etc/shells; then
          command -v zsh | sudo tee -a /etc/shells
        fi
        chsh -s $(which zsh)
        break;;
      [Nn]* ) break;;
      * ) textwrap center "Please answer yes or no.";;
    esac
  done
fi
# }}}

# {{{ oh-my-zsh
if [ "$SHELL" = "$(which zsh)" ]; then
  if [ -d ~/.oh-my-zsh ]; then
    printf "$Purple"
    printf "$Divider"
    printf "$Green"
    nl
    textwrap center "oh-my-zsh already installed, continuing..."
    nl
    let NoChanges=NoChanges+1
  else
    printf "$Yellow"
    printf "$Divider"
    nl
    textwrap center "Would you like to install oh-my-zsh? [y/N]"
    nl
    printf "$Divider"
    printf "$Color_Off"

    hash -r

    while true; do
      eval "printf ' %.0s' {1..$DividerWidthHalf}"
      read -p "" yn
      case $yn in
        [Yy]* )
          git clone https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
          let Success=Success+1
          break;;
        [Nn]* )
          let Failed=Failed+1
          break;;
        * ) textwrap center "Please answer yes or no.";;
      esac
    done
  fi
fi
# }}}

# {{{ tmux color matcher
# ColorStart=$( grep -n "COLORS: START" tmux.conf | cut -d : -f1 )
# ColorEnd=$( grep -n "COLORS: END" tmux.conf | cut -d : -f1 )
# let ColorEnd=ColorEnd+1
# TMUXConf=$( sed "$ColorStart,${ColorEnd}d" tmux.conf )
# TMUXColor1="$( cat ~/.vim/bundle/color-scheme-holokai-for-vim/colors/holokai.vim | grep "SignColumn.*#" | sed -e "s/hi[ ]*SignColumn[ ]*guifg=\(#[^ ]*\).*/\1/g" )"
# TMUXColor2="$( cat ~/.vim/bundle/color-scheme-holokai-for-vim/colors/holokai.vim | grep "SignColumn.*#" | sed -e "s/hi[ ]*SignColumn[ ]*.*guibg=\(#[^ ]*\).*/\1/g" )"
# TMUXColor3="$( cat ~/.vim/bundle/color-scheme-holokai-for-vim/colors/holokai.vim | grep "Pmenu[ ]\+.*#" | sed -e "s/hi[ ]*Pmenu[ ]*.*guibg=\(#[^ ]*\).*/\1/g" )"
# rm tmux.conf
# echo "# COLORS: START" >> tmux.conf
# echo "COLOR_STATUS_FG='$TMUXColor1'" >> tmux.conf
# echo "COLOR_STATUS_BG='$TMUXColor2'" >> tmux.conf
# echo "COLOR_CURRENT_STATUS_BG='$TMUXColor3'" >> tmux.conf
# echo "# COLORS: END" >> tmux.conf
# echo "" >> tmux.conf
# echo "$TMUXConf" >> tmux.conf
# }}}

# {{{ Link Setting Files
printf "$Purple"
printf "$Divider"
nl
textwrap center "Linking settings..."
nl
printf "$Divider"
nl

for file in vimrc vimrc.bundles tmux.conf zshrc aliasrc bash_profile bashrc; do
  rm ~/.$file > /dev/null 2>&1
  ln $file ~/.$file
  printf "$Yellow"
  textwrap center "Linked $file to ~/.$file"
done

rm ~/.config/nvim/init.vim
ln vimrc ~/.config/nvim/init.vim
printf "$Yellow"
textwrap center "Linked vimrc to ~/.config/nvim/init.vim"

printf "$Green"
nl
textwrap center "Finished linking..."
nl
# }}}

# {{{ Results
printf "$White"
printf "$Divider"
nl
textwrap center "RESULTS"
nl
printf "$Divider"

printf "$Green"
nl
textwrap center "$Success item(s) were successful."
nl
printf "$Yellow"
nl
textwrap center "$NoChanges item(s) have had no changes."
nl
printf "$Red"
nl
textwrap center "$Failed item(s) were unsuccessful."
nl
# }}}

printf "$Color_Off"
