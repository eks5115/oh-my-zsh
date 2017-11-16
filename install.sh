
#########################
#########################
###
# prepare

isLinux=true
if [ `uname -s` = 'Linux' ]; then
	 isLinux=true
else
	isLinux=false
fi

if [ ! -n "$ZSH" ]; then
	ZSH=~/.oh-my-zsh
fi

PLUGINS=${ZSH}/plugins

#########################
###
# function

inArray() {
	for i in $2
	do
		if [ $1 = ${i} ];then
			echo true
			return
		fi
	done

	echo false
}

installZSH() {
	if [ ! `which zsh` ];then
		if [ ${isLinux} = true ];then
			sudo apt-get install zsh
		else
			brew install zsh
		fi
	fi
}

installOfficial() {
	if [ ! -e ${ZSH} ]; then
	  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh|sed '/env zsh$/d')"
	fi
}

installPlugins() {
	# plugin zsh-autosuggestions
	if [ ! -e ${PLUGINS}/zsh-autosuggestions ]; then
		git clone git://github.com/zsh-users/zsh-autosuggestions ${PLUGINS}/zsh-autosuggestions
	#else
		#git pull
	fi

	newPluginsArray=('zsh-autosuggestions' 'autojump')

	# write plugin to .zshrc
	oldPluginsArray=(`sed -n '/^plugins=(/{n; p;}' ~/.zshrc`)

	index=0
	merge=(${oldPluginsArray[*]})
	length=${#merge[*]}
	for i in ${newPluginsArray[*]}
	do
		if [ ! `inArray ${i} "${oldPluginsArray[*]}"` = true ];then
			let "index++"
			let "ind=length+index"
			merge[${ind}]=${i}
		fi
	done

	if [ ${isLinux} = true ];then
		sed -i "/^plugins=(/{n;s/.*/${merge[*]}/;}" ~/.zshrc
	else
		sed -i '' "/^plugins=(/{n;s/.*/${merge[*]}/;}" ~/.zshrc
	fi

}

#########################
###
# execute

# install zsh
installZSH

# install official oh-my-zsh
installOfficial

# install plugins
installPlugins

# source
env zsh
