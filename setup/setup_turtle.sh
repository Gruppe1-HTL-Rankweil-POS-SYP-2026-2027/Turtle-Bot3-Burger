: "${WIFI_PWD:?WIFI_PWD is required}"
: "${WIFI_SSID:?WIFI_SSID is required}"

#--- update packet list and upgrade packages
sudo apt update
sudo apt upgrade -y

# --------- ros2 jazzy install
sudo apt install -y curl gnupg lsb-release software-properties-common locales mesa-utils

sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

sudo apt update && sudo apt install -y curl
sudo curl -L https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \ -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed- by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" \ | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update
sudo apt upgrade -y
sudo apt install -y ros-jazzy-desktop ros-dev-tools

echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
source ~/.bashrc

printenv ROS_DISTRO
ros2 --help
rviz2 --help

# ---------- pull github repo

cd ~
git pull

#--- make tools executable
cd ~/Turtle-Bot3-Burger/setup/tools/
sudo chmod +x pull.sh
sudo chmod +x start.sh
sudo chmod +x update.sh

#----- setup services
cd ~/Turtle-Bot3-Burger/setup/services
cp turtle_bot_pull.service /etc/systemd/system/
cp turtle_bot_start.service /etc/systemd/system/
cp turtle_bot_update.service /etc/systemd/system/


sudo systemctl daemon-reload
sudo systemctl enable turtle_bot_pull.service
sudo systemctl enable turtle_bot_start.service
sudo systemctl enable turtle_bot_update.service

#---- connect to wifi
nmcli device wifi connect "$WIFI_SSID" password "$WIFI_PWD"

sleep 10
sudo restart