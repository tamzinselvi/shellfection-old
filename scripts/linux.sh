# {{{ Install Packages
for pkg in libevent-dev libncurses-dev pkg-config vim silversearcher-ag cmatrix wget tig pandoc lynx automake; do
  printf "$Purple"
  printf "$Divider"
  nl
  textwrap center "Checking for $pkg..."
  nl
  printf "$Divider"

  if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
    printf "$Green"
    nl
    textwrap center "$pkg is already installed, continuing..."
    nl
    let NoChanges=NoChanges+1
  else
    printf "$Yellow"
    nl
    textwrap center "$pkg not found, installing..."
    nl
    sudo apt-get install -y $pkg
    let Success=Success+1
  fi
done
# }}}

# {{{ tmux@latest
printf "$Purple"
printf "$Divider"
nl
textwrap center "Build and install latest tmux version? [y/N]"
nl
printf "$Divider"
printf "$Color_Off"

while true; do
  eval "printf ' %.0s' {1..$DividerWidthHalf}"
  read -p "" yn
  case $yn in
    [Yy]* )
      git clone https://github.com/tmux/tmux
      cd tmux
      sh autogen.sh
      ./configure && make
      sudo mv tmux /usr/bin/tmux
      cd ..
      rm -rf tmux
      printf "$Yellow"
      nl
      textwrap center "Finished installing tmux..."
      nl
      let Success=Success+1
      break;;
    [Nn]* )
      printf "$Green"
      nl
      textwrap center "Skipping tmux install..."
      nl
      let NoChanges=NoChanges+1
      break;;
    * ) textwrap center "Please answer yes or no.";;
  esac
done

printf "$Divider"
nl
# }}}
