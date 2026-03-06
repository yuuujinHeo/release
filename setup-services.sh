#!/bin/bash

echo "================================================"
echo "  RB Mobile systemd 서비스 설치 스크립트"
echo "================================================"

# root 권한 확인
if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] sudo로 실행해주세요."
    echo "  sudo ./install_services.sh"
    exit 1
fi

# -----------------------------------------------
# 1. sudoers 설정 (패스워드 없이 systemctl 사용)
# -----------------------------------------------
echo ""
echo "[1/5] sudoers 설정 중..."

SUDOERS_FILE=/etc/sudoers.d/rainbow-systemctl
if [ -f "$SUDOERS_FILE" ]; then
    echo "  이미 등록되어 있습니다. 스킵."
else
    echo "rainbow ALL=(ALL) NOPASSWD: /bin/systemctl" > "$SUDOERS_FILE"
    chmod 440 "$SUDOERS_FILE"
    echo "  완료"
fi

# wmctrl 설치 확인
if ! command -v wmctrl &> /dev/null; then
    echo "  wmctrl 설치 중..."
    apt-get install -y wmctrl > /dev/null 2>&1
    echo "  wmctrl 설치 완료"
fi

# -----------------------------------------------
# 2. 기존 서비스 정리
# -----------------------------------------------
echo ""
echo "[2/5] 기존 서비스 정리 중..."

systemctl stop slamnav.service 2>/dev/null
systemctl stop rb-main-mobile.service 2>/dev/null
systemctl disable slamnav.service 2>/dev/null
systemctl disable rb-main-mobile.service 2>/dev/null
rm -f /etc/systemd/system/slamnav.service
rm -f /etc/systemd/system/rb-main-mobile.service

echo "  완료"

# -----------------------------------------------
# 3. MAIN_MOBILE 서비스 파일 생성
# -----------------------------------------------
echo ""
echo "[3/5] rb-main-mobile.service 생성 중..."

cat > /etc/systemd/system/rb-main-mobile.service << 'EOF'
[Unit]
Description=RB Main Mobile
After=network.target graphical-session.target display-manager.service
Wants=graphical-session.target

[Service]
Type=simple
User=rainbow
WorkingDirectory=/home/rainbow/RB_MOBILE/release
Environment=DISPLAY=:0
Environment=LD_LIBRARY_PATH=/home/rainbow/OrbbecSDK/lib/linux_x64
Environment=PULSE_SERVER=unix:/run/user/1000/pulse/native
Environment=XDG_RUNTIME_DIR=/run/user/1000
ExecStartPre=/bin/sleep 5
ExecStart=/home/rainbow/RB_MOBILE/release/MAIN_MOBILE
Restart=always
RestartSec=5
StartLimitIntervalSec=0

[Install]
WantedBy=graphical.target
EOF

echo "  완료"

# -----------------------------------------------
# 4. SLAMNAV 서비스 파일 생성 (startslam.sh 사용)
# -----------------------------------------------
echo ""
echo "[4/5] slamnav.service 생성 중..."

cat > /etc/systemd/system/slamnav.service << 'EOF'
[Unit]
Description=SLAMNAV Watchdog
After=network.target rb-main-mobile.service
Wants=rb-main-mobile.service

[Service]
Type=simple
User=rainbow
WorkingDirectory=/home/rainbow/RB_MOBILE/release
Environment=DISPLAY=:0
Environment=LD_LIBRARY_PATH=/home/rainbow/OrbbecSDK/lib/linux_x64
Environment=PULSE_SERVER=unix:/run/user/1000/pulse/native
Environment=XDG_RUNTIME_DIR=/run/user/1000
ExecStartPre=/bin/sleep 5
ExecStart=/bin/bash /home/rainbow/RB_MOBILE/sh/startslam.sh
ExecStartPost=/bin/bash -c 'sleep 3 && DISPLAY=:0 wmctrl -a MAIN_MOBILE'
Restart=always
RestartSec=5
StartLimitIntervalSec=0

[Install]
WantedBy=graphical.target
EOF

echo "  완료"

# -----------------------------------------------
# 5. 서비스 등록 및 시작
# -----------------------------------------------
echo ""
echo "[5/5] 서비스 등록 및 시작 중..."

systemctl daemon-reload

systemctl enable rb-main-mobile.service
systemctl enable slamnav.service

systemctl start rb-main-mobile.service
sleep 5
systemctl start slamnav.service

echo "  완료"

# -----------------------------------------------
# 결과 출력
# -----------------------------------------------
echo ""
echo "================================================"
echo "  설치 완료! 서비스 상태:"
echo "================================================"
echo ""
systemctl status rb-main-mobile.service --no-pager | head -10
echo ""
systemctl status slamnav.service --no-pager | head -10
echo ""
echo "================================================"
echo "  유용한 명령어"
echo "================================================"
echo ""
echo "  # 상태 확인"
echo "  sudo systemctl status rb-main-mobile.service"
echo "  sudo systemctl status slamnav.service"
echo ""
echo "  # 로그 실시간 확인"
echo "  journalctl -u rb-main-mobile.service -f"
echo "  journalctl -u slamnav.service -f"
echo ""
echo "  # 서비스 재시작"
echo "  sudo systemctl restart rb-main-mobile.service"
echo "  sudo systemctl restart slamnav.service"
echo ""
echo "  # 서비스 중지"
echo "  sudo systemctl stop rb-main-mobile.service"
echo "  sudo systemctl stop slamnav.service"
echo "================================================"

# -----------------------------------------------
# bashrc에 단축 명령어 추가
# -----------------------------------------------
echo ""
echo "  bashrc에 단축 명령어 추가 중..."

BASHRC=/home/rainbow/.bashrc
MARKER="# RB Mobile 단축 명령어"

if grep -q "$MARKER" "$BASHRC"; then
    echo "  이미 등록되어 있습니다. 스킵."
else
    cat >> "$BASHRC" << 'EOF'

# RB Mobile 단축 명령어
alias ui-restart='sudo systemctl restart rb-main-mobile.service'
alias ui-stop='sudo systemctl stop rb-main-mobile.service'
alias slamnav-restart='sudo systemctl restart slamnav.service'
alias slamnav-stop='sudo systemctl stop slamnav.service'
alias rb-status='sudo systemctl status rb-main-mobile.service && sudo systemctl status slamnav.service'
alias rb-log='journalctl -u rb-main-mobile.service -u slamnav.service -f'
EOF
    echo "  완료"
fi

echo ""
echo "================================================"
echo "  단축 명령어 (터미널 재시작 후 사용 가능)"
echo "================================================"
echo "  ui-restart      : MAIN_MOBILE 재시작"
echo "  ui-stop         : MAIN_MOBILE 중지"
echo "  slamnav-restart : SLAMNAV 재시작"
echo "  slamnav-stop    : SLAMNAV 중지"
echo "  rb-status       : 두 서비스 상태 확인"
echo "  rb-log          : 두 서비스 로그 실시간 확인"
echo "================================================"
echo ""
echo "  ※ SLAMNAV는 startslam.sh(while 루프)로 관리됩니다."
echo "  ※ MAIN_MOBILE Kill All 이후 5초 대기 후 재시작됩니다."
echo "  ※ 단축 명령어는 패스워드 없이 사용 가능합니다."
echo ""
echo "  지금 바로 적용하려면:"
echo "  source ~/.bashrc"
echo "================================================"
