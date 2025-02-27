#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y bc bison build-essential ccache curl flex g++-multilib gcc-multilib git git-lfs gnupg gperf imagemagick lib32readline-dev lib32z1-dev libelf-dev liblz4-tool libsdl1.2-dev libssl-dev \
  libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev lib32ncurses5-dev libncurses5 libncurses5-dev unzip tmux python-is-python3

mkdir -p ~/bin
mkdir -p ~/android/lineage

wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
unzip platform-tools-latest-linux.zip -d ~

curl https://storage.googleapis.com/git-repo-downloads/repo >~/bin/repo
chmod a+x ~/bin/repo

# shellcheck disable=SC2016
echo '
# add Android SDK platform tools to path
if [ -d "$HOME/platform-tools" ] ; then
    PATH="$HOME/platform-tools:$PATH"
fi

# set PATH so it includes users private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache' >>~/.profile

git config --global user.email "placeholder"
git config --global user.name "placeholder"
git config --global color.ui false

git lfs install
ccache -M 50G

mkdir -p ~/android/lineage/rbe
wget https://github.com/LesVu/aosp_buildscript/releases/download/_1/reclient-0.172.0-linux-amd64.zip
unzip reclient-0.172.0-linux-amd64.zip -d ~/android/lineage/rbe
rm reclient-0.172.0-linux-amd64.zip

# shellcheck source=/dev/null
source ~/.profile
cd ~/android/lineage || exit 1
REPO_URL="https://gerrit.googlesource.com/git-repo" repo init -u https://github.com/LineageOS/android.git -b lineage-22.1 --git-lfs --depth=1
