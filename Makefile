.PHONY: all
all: v z k


.PHONY: v
v: ~/.vimrc

~/.vimrc: vimrc
	cp $< $@


.PHONY: z
z: ~/.zshrc

~/.zshrc: zshrc.zsh
	cp $< $@


.PHONY: k
k: ~/.config/kak/kakrc ~/.config/kak/colors/dedelala.kak

~/.config/kak/kakrc: kakrc
	[[ -e `dirname $@` ]] || mkdir -p `dirname $@`
	cp $< $@

~/.config/kak/colors/dedelala.kak: dedelala.kak
	[[ -e `dirname $@` ]] || mkdir -p `dirname $@`
	cp $< $@

