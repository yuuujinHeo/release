#!/bin/bash

# 필요한 패키지 업데이트 및 설치
sudo apt-get update

sudo apt install libqt5websockets5-dev -y
sudo apt-get install qtmultimedia5-dev -y
sudo apt-get install libquazip5-dev -y
sudo apt-get -y install sshpass -y
sudo apt install qtdeclarative5-dev -y # vtk 빌드를 위한 QT5Qml, QT5Quick 설치
sudo apt install libvtk9-qt-dev -y
sudo apt install libpcl-dev -y
sudo apt install libeigen3-dev -y
sudo apt install libopencv-dev -y
sudo apt install libopencv-contrib-dev -y
sudo apt install libboost-all-dev -y

# 팀뷰어 설치 파일을 Home 경로에 다운로드
wget -P ~/ https://download.teamviewer.com/download/linux/teamviewer_arm64.deb

# 다운로드한 설치 파일을 이용하여 팀뷰어 설치
sudo apt install ~/teamviewer_arm64.deb -y

# autostart.sh 파일 교체
#cp ~/RB_MOBILE/sh/autostart.sh ~/RB_MOBILE/release/autostart.sh
mv ~/RB_MOBILE/release/autostart.sh ~/RB_MOBILE/sh/autostart.sh

# release 경로에 있는 autostart.sh 파일 삭제
rm ~/RB_MOBILE/release/autostart.sh

# sh 폴더에 있는 autostart.sh 파일에 실행 권한 부여
chmod +x ~/RB_MOBILE/sh/autostart.sh

# 스크립트 자체 삭제
rm -- "$0"

echo "모든 작업이 완료되었습니다."

