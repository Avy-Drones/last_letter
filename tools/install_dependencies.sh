#!/usr/bin/env bash

set -ex
# Avoid getting asked for prompts
export DEBIAN_FRONTEND=noninteractive

# Set current working directory to the ros_ws directory
cd "$(dirname "$0")"/../../..

# Install whatever rosdep can cover
apt-get update
rosdep update
rosdep install -i --from-path . --rosdistro ${ROS_DISTRO} -y

apt-get upgrade -y
## Add 3rd party repositories
apt-get install software-properties-common -y
### iir1
add-apt-repository ppa:berndporr/dsp -y
## Install packages
apt-get update && apt-get install -y\
    iir1-dev \
    python3-pip \
    vim

# Install pip packages
pip install --upgrade pip
pip install /ros_ws/src/last_letter/last_letter/external/last_letter_lib/
pip3 install -r src/last_letter/tools/requirements.txt

# Patch collections.Iterable removal in Python 3.10+ for pcg_gazebo compatibility
PCG_DIR=$(python3 -c "import pcg_gazebo; import os; print(os.path.dirname(pcg_gazebo.__file__))")
find "$PCG_DIR" -name '*.py' -exec \
    sed -i 's/collections\.Iterable/collections.abc.Iterable/g; s/collections\.Mapping/collections.abc.Mapping/g; s/collections\.MutableMapping/collections.abc.MutableMapping/g; s/collections\.Sequence/collections.abc.Sequence/g' {} +

# Copy aircraft config YAML files to the models directory
cp -r /ros_ws/src/last_letter/last_letter/external/last_letter_lib/last_letter_models/aircraft/* \
    "$HOME/last_letter_models/"
