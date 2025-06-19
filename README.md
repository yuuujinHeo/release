#
해당 브랜치는 25.03.17에 작업한 내용입니다.
H4 Ultra에서 실행하기 위한 브랜치로써, N2+와는 다름을 명시합니다.

결과적으로 해당 브랜치는 S100 플랫폼에서 SRV를 실행하기 위한 브랜치입니다.

---
### UI
https://github.com/yuuujinHeo/UI_MOBILE_TEMP

### SLAMNAVI
https://github.com/RBmobile23/mobile_slamnav2D

### 업데이트
https://github.com/SimonLee9/RB_update
 ### update_srv.sh
----

## 25.06.19 S1002SRV 명시 내역

### UI 동작을 위한 추가 설치
sudo apt-get install qml-module-qtquick-dialogs

### bashrc 경로 설정
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/rainbow/OrbbecSDK/lib/linux_x64
