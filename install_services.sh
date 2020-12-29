#!/bin/bash
## This is the automated script of Headless A2DP Audio for Raspberry Pi 3
## The original services and scripts were created by @mill1000
## Automation Script created by hahagu, UTC 2018-08-02

## Updating System
echo "Updating System"
sudo apt-get update
sudo apt-get upgrade -y
## sudo rpi-update

## Set Name and etc
printf "\n"
echo "Bluetooth Workaround"
echo "This is recommended due to bugs with the integrated wifi."
echo "Option 1. Disable Onboard Bluetooth (Use dongle)"
echo "Option 2. Update BlueZ to 5.50 (Does not work on all cases!)"
echo "Option 3. Do Nothing"
read -p "Choose Option (1/2/3) " btansw
case ${btansw:0:1} in
    1 )
        ## Disable Bluetooth
        printf "\n"
        echo "Disabling Internal Bluetooth"
        printf "\n# Disable onboard Bluetooth\ndtoverlay=pi3-disable-bt" >> /boot/config.txt
        sudo systemctl disable hciuart.service
    ;;
    2 )
        ## Updating from source
        printf "\n"
        echo "Installing Prerequisites"
        sudo apt install libdbus-1-dev libglib2.0-dev libudev-dev libical-dev libreadline-dev -y
        echo "Downloading Source"
        wget http://www.kernel.org/pub/linux/bluetooth/bluez-5.50.tar.xz
        echo "Extracting Source"
        tar xvf bluez-5.50.tar.xz
        cd bluez-5.50
        echo "Configuring"
        ./configure --prefix=/usr --mandir=/usr/share/man --sysconfdir=/etc --localstatedir=/var --enable-experimental 
        echo "Compiling"
        make -j4
        echo "Installing"
        sudo make install
        sudo adduser pi bluetooth
        sudo sed -i -e 's|<allow send_interface="org.bluez.Profile1"/>|<allow send_interface="org.bluez.Profile1"/>\n    <allow send_interface="org.bluez.AlertAgent1"/>\n    <allow send_interface="org.bluez.ThermometerWatcher1"/>\n    <allow send_interface="org.bluez.HeartRateWatcher1"/>\n    <allow send_interface="org.bluez.CyclingSpeedWatcher1"/>|g' /etc/dbus-1/system.d/bluetooth.conf
        sudo sed -i -e 's|<allow send_interface="org.freedesktop.DBus.Properties"/>\n  </policy>|<allow send_interface="org.freedesktop.DBus.Properties"/n  </policy>\n\n  <!-- allow users of bluetooth group to communicate -->\n  <policy group="bluetooth">\n    <allow send_destination="org.bluez"/>\n  </policy>\n\n|g' /etc/dbus-1/system.d/bluetooth.conf
        echo "Cleaning"
        cd ..
        rm -rf ./bluez-5.50*
    ;;
    * )
        printf "\n"
        echo "Skipping.."
    ;;
esac

printf "\n"
echo "Device Name? Currently $(hostname) "
read btname
read -p "Do you want to set the name as $btname? (y/n) " nameansw
case ${nameansw:0:1} in
    y|Y )
        ## Change Hostname
        printf "\n"
        echo "Changing Hostname"
        sudo hostname $btname
        sudo sed -i -e "s/$(hostname)/$btname/g" /etc/hosts
        sudo sed -i -e "s/$(hostname)/$btname/g" /etc/hostname
        sudo service networking restart
    ;;
    * )
        printf "\n"
        echo "Skipping.."
    ;;
esac

## Installing Dependencies
printf "\n"
echo "Installing Dependencies"
sudo apt-get install bluealsa python-dbus

## Make Bluetooth Discoverable
printf "\n"
echo "Making Bluetooth Discoverable"
sudo sed -i -e 's/#DiscoverableTimeout = 0/DiscoverableTimeout = 0/g' /etc/bluetooth/main.conf
echo -e 'power on \ndiscoverable on \nquit' | sudo bluetoothctl

## Create Services
printf "\n"
echo "Creating Services"
sudo cp pi_config/a2dp-agent /usr/local/bin
sudo chmod +x /usr/local/bin/a2dp-agent

sudo cp ./pi_config/bt-agent-a2dp.service /etc/systemd/system
sudo systemctl enable bt-agent-a2dp.service

sudo cp ./pi_config/a2dp-playback.service /etc/systemd/system
sudo systemctl enable a2dp-playback.service

sudo cp ./software/ipod_emulator_service/ipod_emul_daemon.py /usr/local/bin
sudo chmod +x /usr/local/bin/ipod_emul_daemon.py

sudo mv ./pi_config/ipod_emulator.service /etc/systemd/system
sudo systemctl enable ipod_emulator.service





sudo sed -i -e '$i \# Make Bluetooth Discoverable\necho -e "discoverable on \\nquit" | sudo bluetoothctl\n' /etc/rc.local

## Reboot
printf "\n"
echo "Rebooting in 5 seconds.."
sleep 5
sudo reboot