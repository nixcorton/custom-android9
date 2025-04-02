#!/bin/bash

set -e

echo ">>> Установка repo..."
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH

echo ">>> Подготовка директории AOSP..."
mkdir -p ~/aosp
cd ~/aosp

echo ">>> Инициализация Android 9.0.0_r54..."
repo init -u https://android.googlesource.com/platform/manifest -b android-9.0.0_r54
repo sync -j8

echo ">>> Подготовка сборки..."
source build/envsetup.sh
lunch aosp_x86_64-eng

echo ">>> Сборка началась..."
make -j$(nproc)

echo ">>> Архивация результата..."
cd out/target/product/generic_x86_64
tar -czvf ~/android9_x86.tgz system.img userdata.img ramdisk.img kernel

echo ">>> Готово. Архив: ~/android9_x86.tgz"
