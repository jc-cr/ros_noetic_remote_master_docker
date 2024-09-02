#!/bin/bash

# Check if 2 arguments were passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <robot_ip> <robot_hostname>"
    exit 1
fi

# Help flag
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "Usage: $0 <robot_ip> <robot_hostname>"
    exit 0
fi

export ROBOT_IP=$1
export ROBOT_HOSTNAME=$2

# Ensure X11 forwarding is set up correctly
xhost +local:

# Check if docker group exists and current user is a member
if getent group docker > /dev/null 2>&1 && id -nG "$USER" | grep -qw "docker"; then
    # User is in docker group, proceed normally
    docker-compose up -d
    docker-compose exec -e COLUMNS=$(tput cols) -e LINES=$(tput lines) connect_to_ros_noetic_remote_master bash -c "
        source /ros_entrypoint.sh
        exec bash
    "
else
    # User is not in docker group, use sudo
    echo "You are not in the docker group. Running with sudo."
    sudo -E docker-compose up -d
    sudo -E docker-compose exec -e COLUMNS=$(tput cols) -e LINES=$(tput lines) connect_to_ros_noetic_remote_master bash -c "
        source /ros_entrypoint.sh
        exec bash
    "
fi