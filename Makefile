.PHONY: all
all: vim zsh kakoune


~/.vimrc: vim/.vimrc
	cp vim/.vimrc ~/

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

