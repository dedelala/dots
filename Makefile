
~/.vimrc: vim/.vimrc
	cp vim/.zshrc ~/.vimrc

.PHONY: vim
vim: ~/.vimrc


~/.zshrc: zsh/.zshrc
	cp zsh/.zshrc ~/

.PHONY: zsh
zsh: ~/.zshrc


~/.config/kak: kak
	[[ -e ~/.config ]] || mkdir ~/.config
	rm -rf ~/.config/kak
	cp -R kak ~/.config/

.PHONY: kakoune
kakoune: ~/.config/kak
