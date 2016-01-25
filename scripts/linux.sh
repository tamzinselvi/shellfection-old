# {{{ Install Packages
for pkg in libevent-dev libncurses-dev pkg-config vim silversearcher-ag cmatrix wget tig pandoc lynx; do
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
if ! which tmux >/dev/null; then
  printf "$Purple"
  printf "$Divider"
  nl
  textwrap center "Building latest tmux version..."
  nl
  printf "$Divider"
  nl

  sudo apt-get -y install
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
else
  printf "$Green"
  nl
  textwrap center "$tmux is already installed, make sure you are on 2.3..."
  nl
  let NoChanges=NoChanges+1
fi

# }}}
