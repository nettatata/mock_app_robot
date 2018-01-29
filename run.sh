Xvfb :99 -screen 0 1920x1080x24 -ac &
export DISPLAY=:99

robot -i db -i web -i db test.robot
