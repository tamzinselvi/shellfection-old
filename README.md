# Shellfection

This is my personal development kit that I am trying to make compatible with many systems. It's in an early stage right now and has somewhat stability on El Capitan.

I should have versions soon for:

* Raspbian (IP)
* Ubuntu 12 (Unstable)

## Installation

1. Mac Users - Install [iTerm2](https://www.iterm2.com/) if you haven't already
2. `$ git clone https://github.com/tomselvi/shellfection ~/.settings`
3. `$ cd ~/.settings`
4. `$ make install` or `$ ./scripts/install.sh`
5. Go into your iTerm preferences and change font to Ubuntu Powerline, or check out other Powerline fonts [here](https://github.com/powerline/fonts)

## Usage

### make

* `$ make install` Installs any new packages, links settings and untracks local files
* `$ make uninstall` Removes setting files and stops tracking
* `$ make update` Updates to the latest version by uninstalling, fetching origin, stashing changes, rebasing, popping changes and re-installing
* `$ make vundle` Installs any new Vundles

### no-make
* `$ ./scripts/install.sh` Installs any new packages, links settings and untracks local files
* `$ ./scripts/uninstall.sh` Removes setting files and stops tracking
* `$ vim +PluginInstall +qall` Installs any new Vundles

### useful aliases
`$ readme`
Allows pleasurable viewing of markdown in console by specifying file, default=README.md.

`$ http`
Fires up an http server in the cwd on specified port, default=1337

`$ gac or gac -m "i only need a subject"`
git add -A . && git commit

### vim cheatsheet

* `,d` brings up [NERDTree](https://github.com/scrooloose/nerdtree), a sidebar buffer for navigating and manipulating files
* `,t` brings up [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim), a project file filter for easily opening specific files
* `,b` restricts ctrlp.vim to open buffers
* `,a` starts project search with [ag.vim](https://github.com/rking/ag.vim) using [the silver searcher](https://github.com/ggreer/the_silver_searcher) (like ack, but faster)
* `,g` toggle Git gutters using [vim-gitgutter](https://github.com/airblade/vim-gitgutter)
* `,ig` toggle indent guides using [vim-indent-guides](https://github.com/nathanaelkane/vim-indent-guides)
* `ds`/`cs` delete/change surrounding characters (e.g. `"Hey!"` + `ds"` = `Hey!`, `"Hey!"` + `cs"'` = `'Hey!'`) with [vim-surround](https://github.com/tpope/vim-surround)
* `gcc` toggles current line comment
* `gc` toggles visual selection comment lines
* `vii`/`vai` visually select *in* or *around* the cursor's indent
* `Vp`/`vp` replaces visual selection with default register *without* yanking selected text (works with any visual selection)
* `,[space]` strips trailing whitespace
* `<C-]>` jump to definition using ctags
* `,l` begins aligning lines on a string, usually used as `,l=` to align assignments
* `<C-hjkl>` move between windows, shorthand for `<C-w> hjkl`
* [easy-motion](https://github.com/easymotion/vim-easymotion)
  * `,,-wWbBeE` basic easymotion navigation
* [vim-multiple-cursors](https://github.com/terryma/vim-multiple-cursors)
  * when selecting, `<C-n>` select next identical selection
  * `<C-x>` skip selection and continue to next
  * `<C-p>` remove current selection and move backwards
  * proceed to insert, delete and use all cursors simultaneously
  * press `<Esc>` to return to one cursor

### tmux cheatsheet

* `<C-b>$` rename tmux session
* `<C-b>x` kill current tmux pane
* `<C-b>c` create a new tmux tab
* `<C-b>w` list current tabs
* `<C-b>p <C-b>n` previous / next tab
* `<C-b>%` split pane veritcally
* `<C-b>"` split pane horizontally

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## History

TODO: Write history

## Credits

* To [maximum-awesome](https://github.com/square/maximum-awesome) for a good portion of the setup
* any contributors
