#!/bin/bash

PROJ_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Create conda environment
conda create -n foundationpose_ros python=3.10 -y

# Activate conda environment
source $(conda info --base)/etc/profile.d/conda.sh
conda activate foundationpose_ros

# Install dependencies
python -m pip install -r requirements.txt

# Clone source repository of FoundationPose
git clone https://github.com/NVlabs/FoundationPose.git

# Install pybind11
cd ${PROJ_ROOT}/FoundationPose && git clone https://github.com/pybind/pybind11 && \
    cd pybind11 && git checkout v2.10.0 && \
    mkdir build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release -DPYBIND11_INSTALL=ON -DPYBIND11_TEST=OFF && \
    make -j6 && make install

# Install Eigen
cd ${PROJ_ROOT}/FoundationPose && wget https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz && \
    tar xvzf ./eigen-3.4.0.tar.gz && \
    cd eigen-3.4.0 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make install

# Clone and install nvdiffrast
cd ${PROJ_ROOT}/FoundationPose && git clone https://github.com/NVlabs/nvdiffrast && \
    conda activate foundationpose_ros && cd /nvdiffrast && pip install .

# Install mycpp
cd ${PROJ_ROOT}/FoundationPose/mycpp/ && \
rm -rf build && mkdir -p build && cd build && \
cmake .. && \
make -j$(nproc)

# Install mycuda
cd ${PROJ_ROOT}/FoundationPose/bundlesdf/mycuda && \
rm -rf build *egg* *.so && \
python3 -m pip install -e .

cd ${PROJ_ROOT}