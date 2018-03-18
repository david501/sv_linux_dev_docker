#! /bin/bash

root=/home/david/SV/SV

docker run --privileged -e "DISPLAY=unix:0.0" -v="/tmp/.X11-unix:/tmp/.X11-unix:rw" -it -v $root:/home/SV david501/sv:linux_dev
