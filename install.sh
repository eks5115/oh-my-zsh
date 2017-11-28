#!/bin/bash

#########################
#########################
###
# prepare
git clone https://github.com/eks5115/oh-my-zsh.git /tmp/oh-my-zsh/
cd /tmp/oh-my-zsh/

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

myPlugins=(`ls ./plugins`)

getPluginNames() {
  tmpPluginNames=()
  i=0
  while(( $i<${#myPlugins[*]} ))
  do
    tmpPluginNames[${i}]=$(basename ${myPlugins[${i}]} .git.plugin)
    let "i++"
  done
  echo ${tmpPluginNames[*]}
}
pluginNames=(`getPluginNames`)
ohMyZshPluginNames=('autojump')

pullGitPlugins() {
  i=0
  while(( $i<${#myPlugins[*]} ))
  do
    if [ ! -e ${PLUGINS}'/'$(basename ${myPlugins[${i}]} .git.plugin) ];then
      git clone `cat "plugins/${myPlugins[${i}]}"` ${PLUGINS}/$(basename ${myPlugins[${i}]} .git.plugin)
    fi

    let "i++"
  done
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

installGit() {
  if [ ! `which git` ];then
    if [ ${isLinux} = true ];then
      sudo apt-get install git
    else
      brew install git
    fi
  fi
}

installOhMyZsh() {
  if [ ! -e ${ZSH} ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh|sed '/env zsh$/d')"
  fi
}

installPlugins() {
#  # plugin zsh-autosuggestions
#  if [ ! -e ${PLUGINS}/zsh-autosuggestions ]; then
#    git clone git://github.com/zsh-users/zsh-autosuggestions ${PLUGINS}/zsh-autosuggestions
#  fi
#
#  # plugin zsh-autosuggestions
#  if [ ! -e ${PLUGINS}/zsh-syntax-highlighting ]; then
#    git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ${PLUGINS}/zsh-syntax-highlighting
#  fi

  pullGitPlugins

  newPluginsArray=(${ohMyZshPluginNames[*]} ${pluginNames[*]})

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

###
# install zsh
installZSH

###
# install oh-my-zsh
installOhMyZsh

###
# install git
installGit

###
# install plugins
installPlugins

###
# source

cd ~

if [ "/bin/zsh" != "${SHELL}" ];then
  env zsh
fi
