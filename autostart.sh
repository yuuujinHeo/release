#!/bin/bash

# startextproc.sh 프로세스 종료
pid=$(ps -ef | grep "startextproc.sh" | grep -v 'grep' | awk '{print $2}')
if [ -z "$pid" ]; then
    echo "startextproc.sh is not running"
else
    kill -9 $pid
fi

# startslam.sh 프로세스 종료
pid=$(ps -ef | grep "startslam.sh" | grep -v 'grep' | awk '{print $2}')
if [ -z "$pid" ]; then
    echo "startslam.sh is not running"
else
    kill -9 $pid
fi

# MAIN_MOBILE 프로세스 종료
pid=$(ps -ef | grep "MAIN_MOBILE" | grep -v 'grep' | awk '{print $2}')
if [ -z "$pid" ]; then
    echo "MAIN_MOBILE is not running"
else
    kill -9 $pid
fi

# release 디렉토리로 이동
cd ~/RB_MOBILE/release

# srv-update.sh 파일 실행 여부 확인
if [ -f "./srv-update.sh" ]; then
    echo "Running srv-update..."
    ./srv-update.sh
    echo "Now running MAIN_MOBILE..."
    ./MAIN_MOBILE
else
    echo "srv-update not found, running MAIN_MOBILE..."
    ./MAIN_MOBILE
fi

exit 0

