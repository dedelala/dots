.PHONY: all
all: v z k


.PHONY: v
v: ~/.vimrc

~/.vimrc: vim/.vimrc
	cp $< $@


.PHONY: z
z: ~/.zshrc

~/.zshrc: zsh/.zshrc
	cp $< $@


.PHONY: k
k: ~/.config/kak/kakrc ~/.config/kak/colors/dedelala.kak

~/.config/kak/kakrc: kak/kakrc
	[[ -e `dirname $@` ]] || mkdir -p `dirname $@`
	cp $< $@

~/.config/kak/colors/dedelala.kak: kak/colors/dedelala.kak
	[[ -e `dirname $@` ]] || mkdir -p `dirname $@`
	cp $< $@

