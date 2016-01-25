.PHONY: default install vundle

default: install

install:
	@./scripts/install.sh

uninstall:
	@./scripts/uninstall.sh

vundle:
	vim +PluginInstall +qall

update:
	make uninstall
	git fetch origin
	git stash
	git rebase origin/master
	git stash pop
	make install
	make vundle
