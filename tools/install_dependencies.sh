#!/usr/bin/env bash

set -ex
# Avoid getting asked for prompts
export DEBIAN_FRONTEND=noninteractive

# Set current working directory to the ros_ws directory
cd "$(dirname "$0")"/../../..

# Install whatever rosdep can cover
apt-get update
rosdep update --include-eol-distros
rosdep install -i --from-path . --rosdistro ${ROS_DISTRO} -y

# Install system dependencies not covered by rosdep
apt-get install -y libignition-common3-graphics
## Install packages
apt-get install -y \
    python3-pip \
    vim \
    cmake \
    git

# Install iir1 from source (PPA only has amd64 packages)
git clone https://github.com/berndporr/iir1.git /tmp/iir1
cd /tmp/iir1 && cmake -S . -B build && cmake --build build && cmake --install build
ldconfig
cd "$(dirname "$0")"/../../..

# Install pip packages
pip install "cython<3"
pip install /ros_ws/src/last_letter/last_letter/external/last_letter_lib/
pip3 install -r src/last_letter/tools/requirements.txt
