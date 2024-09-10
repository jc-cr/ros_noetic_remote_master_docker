# Use the official ROS Noetic image as the base
FROM osrf/ros:noetic-desktop-focal

# Install RViz and necessary packages for software rendering and debugging
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-rviz \
    ros-${ROS_DISTRO}-image-transport-plugins \
    ros-${ROS_DISTRO}-teleop-twist-keyboard \
    libgl1-mesa-dri \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libxext6 \
    libx11-6 \
    bash-completion \
    iputils-ping \
    net-tools \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# Set up environment variables
ENV ROS_DISTRO noetic
ENV LIBGL_ALWAYS_SOFTWARE 1
ENV DISPLAY=:0

# Create a script to update /etc/hosts
RUN echo '#!/bin/bash\n\
if [ ! -z "$ROBOT_IP" ]; then\n\
  echo "$ROBOT_IP $ROBOT_HOSTNAME" >> /etc/hosts\n\
fi\n\
exec "$@"' > /update-hosts.sh && chmod +x /update-hosts.sh

# Set the script as the entry point
ENTRYPOINT ["/update-hosts.sh"]
CMD ["bash"]