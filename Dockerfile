FROM ghcr.io/screamlab/pros_base_image:0.0.0
ENV ROS_DISTRO=humble

COPY . /tmp
RUN mv /tmp/src /workspaces/src
    
WORKDIR /workspaces

# bootstrap rosdep
RUN apt update && rosdep update --rosdistro $ROS_DISTRO && \
    apt-get install ros-$ROS_DISTRO-vision-opencv -y && \
# setup colcon mixin and metadata
    colcon mixin update && \
    colcon metadata update && \
    rosdep install -q -y -r --from-paths src --ignore-src && \
    source /opt/ros/humble/setup.bash && colcon build --mixin release && \
    source ./install/setup.bash

ENTRYPOINT [ "/ros_entrypoint.bash" ]
CMD ["/bin/bash", "-l"]