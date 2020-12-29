# Setup bluetooth a2dp sink

https://scribles.net/streaming-bluetooth-audio-from-phone-to-raspberry-pi-using-alsa/


https://gist.github.com/mill1000/74c7473ee3b4a5b13f6325e9994ff84c
https://gist.github.com/mill1000/74c7473ee3b4a5b13f6325e9994ff84c

sudo unzip -p 2019-04-08-raspbian-stretch-lite.zip | sudo dd of=/dev/sda bs=4M conv=fsync status=progress


# Setup and connect to zero without wifi:

https://raspberrypi.stackexchange.com/questions/73523/connect-pi-zero-via-usb-rndis-gadget-to-ubuntu-17-04





https://github.com/adrianomarto/soft_uart/blob/master/README.md

## Reroute audio to gpio header:


https://raspberrypi.stackexchange.com/questions/49600/how-to-output-audio-signals-through-gpio

https://github.com/raspberrypi/firmware/blob/master/boot/overlays/README

audremap GPIO12-GPIO13

https://raspberrypi.stackexchange.com/questions/83610/gpio-pinout-orientation-raspberypi-zero-w





#ipod interface

https://stackoverflow.com/questions/1720568/whats-needed-to-use-the-apple-accessory-protocol

https://github.com/oandrew/ipod-gadget


http://pinouts.ru/PortableDevices/ipod_pinout.shtml
https://nuxx.net/wiki/iPod_Dock_Connector


https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=163182



sudo apt-get install git




sudo apt-get install python3-serial
sudo apt-get install bluealsa


sudo cp *.service /lib/systemd/system
sudo cp a2dp-agent /usr/local/bin
sudo cp ipod_emul_daemon.py /usr/local/bin




