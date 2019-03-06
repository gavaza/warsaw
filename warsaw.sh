#!/bin/bash

SESSION_NAME=warsaw-$(tr -dc 0-9 < /dev/urandom  | head -c 6)

xhost +local:

docker run -t --rm --entrypoint "/opt/warsaw/warsaw.sh" --name=$SESSION_NAME \
	   --user=$USERNAME:$USERNAME \
           -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
	   warsaw

xhost -local:
