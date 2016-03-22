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
textwrap center "Installing custom executables..."
nl
printf "$Divider"
nl

for file in pipeseroni-pipes shellfection-screensavers; do
  cp bin/$file /usr/local/bin/$file
  chmod +x /usr/local/bin/$file
  printf "$Yellow"
  textwrap center "Copied $file to /usr/local/bin/$file"
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

# {{{ Install Vundle
printf "$Purple"
printf "$Divider"
nl
textwrap center "Installing Vundle and Vundles..."
nl
printf "$Divider"

if [ -a ~/.vim/bundle/Vundle.vim ]; then 
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
  mkdir ~/.vim >/dev/null 2>&1
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
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
# {{{ Link Setting Files
printf "$Purple"
printf "$Divider"
nl
textwrap center "Linking settings..."
nl
printf "$Divider"
nl

for file in vimrc vimrc.local vimrc.bundles vimrc.bundles.local tmux.conf tmux.conf.local zshrc zshrc.local aliasrc aliasrc.local bash_profile bashrc bashrc.local; do
  rm ~/.$file > /dev/null 2>&1
  ln $file ~/.$file
  printf "$Yellow"
  textwrap center "Linked $file to ~/.$file"
done

printf "$Green"
nl
textwrap center "Finished linking..."
nl
# }}}
  done
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

for file in vimrc vimrc.local vimrc.bundles vimrc.bundles.local tmux.conf tmux.conf.local zshrc zshrc.local aliasrc aliasrc.local bash_profile bashrc bashrc.local; do
  rm ~/.$file > /dev/null 2>&1
  ln $file ~/.$file
  printf "$Yellow"
  textwrap center "Linked $file to ~/.$file"
done

printf "$Green"
nl
textwrap center "Finished linking..."
nl
# }}}

# {{{ Stop tracking local files
printf "$Purple"
printf "$Divider"
nl
textwrap center "Untracking local files..."
nl
printf "$Divider"

for file in vimrc.local vimrc.bundles.local zshrc.local aliasrc.local bashrc.local tmux.conf.local; do
  git update-index --assume-unchanged $file
  printf "$Yellow"
  textwrap center "Stopped tracking $file"
done

printf "$Green"
nl
textwrap center "Finished untracking..."
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
