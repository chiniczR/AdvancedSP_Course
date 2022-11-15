# Stonefish simulator - build docker container
FROM osrf/ros:melodic-desktop-full
# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
RUN apt-get update
RUN apt-get install -y \
    gcc \
    g++ \
    gcc-multilib \
    g++-multilib \
    build-essential \
    xutils-dev \
    libsdl2-dev \
    libsdl2-gfx-dev \
    libsdl2-image-dev \
    libsdl2-mixer-dev \
    libsdl2-net-dev \
    libsdl2-ttf-dev \
    libreadline6-dev \
    libncurses5-dev \
    mingw-w64 \
    cmake
RUN apt-get install -y python-pip python3-pip python3-dev git-core unzip zip curl bash
RUN apt-get install libglm-dev

# Install gdown and donwload object models from drive
RUN pip3 install gdown
    # && \
    # gdown --folder "https://drive.google.com/drive/folders/154pd_raZcUTigslPxCQn-KeTVy5TqE2m?usp=sharing"

# Stonefish
WORKDIR /home/

RUN git clone "https://github.com/patrykcieslak/stonefish.git"
RUN cd stonefish
RUN mkdir -p build
RUN cd build
# RUN cmake ..
WORKDIR /home/stonefish/build
# RUN cmake ..
RUN cmake -DBUILD_TESTS=ON ..
# # RUN make -jX
RUN make -j8

# RUN make