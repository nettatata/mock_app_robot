#use_chrome.sh
#Xvfb :99 -screen 0 1920x1080x24 -ac &
#export DISPLAY=:99

use_chrome_headless.sh

robot -i db -i web -i db test.robot

pkill chrome
pkill firefox
pkill Xvfb                

