#!/usr/bin/env bash

if [ ! -n "$ZSH" ]; then
	ZSH=~/.oh-my-zsh
fi

PLUGINS=${ZSH}/plugins

installOfficial() {
	if [ ! -e ${ZSH} ]; then
		sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	fi
}

installPlugins() {
	# plugin zsh-autosuggestions
	if [ ! -e ${PLUGINS}/zsh-autosuggestions ]; then
		git clone git://github.com/zsh-users/zsh-autosuggestions ${PLUGINS}/zsh-autosuggestions
	fi

	# TODO write plugin to .zshrc
}


# install official oh-my-zsh
installOfficial

# install plugins
installPlugins