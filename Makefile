.PHONY: all
all: v z k blep


.PHONY: v
v: ~/.vimrc

~/.vimrc: vimrc
	cp $< $@


.PHONY: z
z: ~/.zshrc

~/.zshrc: zsh/*
	cat zsh/init.zsh zsh/fn-* zsh/rc.zsh > $@


.PHONY: k
k: ~/.config/kak/kakrc ~/.config/kak/colors/dedelala.kak

~/.config/kak/kakrc: kakrc
	[[ -e `dirname $@` ]] || mkdir -p `dirname $@`
	cp $< $@

~/.config/kak/colors/dedelala.kak: dedelala.kak
	[[ -e `dirname $@` ]] || mkdir -p `dirname $@`
	cp $< $@


.PHONY: blep
blep: ~/.config/kitty/kitty.conf
	
~/.config/kitty/kitty.conf: kitty.conf
	[[ -e `dirname $@` ]] || mkdir -p `dirname $@`
	cp $< $@
