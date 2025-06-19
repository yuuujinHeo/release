#!/bin/bash

pm2 delete all
pm2 start --cwd ~/RB_MOBILE/release --name UI ~/RB_MOBILE/release/MAIN_MOBILE
pm2 start --cwd ~/RB_MOBILE/release --name SLAMNAV ~/RB_MOBILE/release/SLAMNAV

pm2 save
startup_command=$(pm2 startup | grep 'sudo' | tail -n 1)
eval $startup_command
break
;;
