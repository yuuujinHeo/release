#!/bin/bash

sudo apt update

sudo apt install qml-module-qtquick-* qml-module-qtmultimedia qml-module-qt-labs-platform libqt5serialport5-dev qtquickcontrols2-5-dev ccache libusb-1.0-0-dev libqt5multimedia5-plugins -y libqt5websockets5-dev -y qtmultimedia5-dev -y qtdeclarative5-dev -y

sudo apt install build-essential make -y

sudo apt install libquazip5-dev -y

sudo apt install python3-pip -y

pip3 install gtts

# sudo apt install gstreamer1.0-libav gstreamer1.0-vaapi ubuntu-restricted-extras -y
sudo DEBIAN_FRONTEND=noninteractive apt install gstreamer1.0-libav gstreamer1.0-vaapi ubuntu-restricted-extras -y --no-install-recommends

# 스크립트 실행 후 srv-update 파일 삭제
sudo rm "$0"
