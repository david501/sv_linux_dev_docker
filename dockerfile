FROM  ubuntu

# Set the working directory 
WORKDIR /home/SV

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libboost-all-dev \
    curl \    
    unzip \
    && apt-get autoremove && apt-get autoclean && apt-get clean 


# Install Gstreamer , OpenGL and ...
RUN apt-get update  && apt-get install -y  \
    libgstreamer-plugins-base1.0-dev \
    libgles2-mesa-dev \
    libglm-dev \
    libpcap-dev \
    libyaml-cpp-dev \
    python-yaml \
    libnlopt-dev \
    mesa-utils \
    && apt-get autoremove && apt-get autoclean && apt-get clean 

# Begin to install OpenCV ... 
RUN apt-get update && apt-get install -y \
    # required 
    libgtk-3-dev \
    pkg-config \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \ 
    # optional 
    python-dev \
    python-numpy \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libjasper-dev \
    libdc1394-22-dev \
    v4l-utils \
    libgphoto2-dev \
    && apt-get autoremove && apt-get autoclean && apt-get clean 

# Build OpenCV 
ARG OPENCV_VERSION="3.4.1"
RUN cd /tmp \
    && curl -OL https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip \
    && unzip $OPENCV_VERSION.zip -d /tmp \
    && mkdir -p /tmp/opencv-$OPENCV_VERSION/build \
    && cd /tmp/opencv-$OPENCV_VERSION/build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DWITH_FFMPEG=ON -DWITH_OPENEXR=OFF -DBUILD_TIFF=OFF -DWITH_CUDA=OFF -DWITH_NVCUVID=OFF -DBUILD_PNG=OFF .. \
    && make \
    && make install \
    && rm -rf /tmp/* /var/tmp/*

# Configure OpenCV
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf \
    && ldconfig \
    && ln /dev/null /dev/raw1394 # hide warning - http://stackoverflow.com/questions/12689304/ctypes-error-libdc1394-error-failed-to-initialize-libdc1394

# Install Cairo
RUN cd /tmp \
    && curl -OL https://www.cairographics.org/releases/cairo-1.14.12.tar.xz \
    && tar xvfJ cairo-1.14.12.tar.xz \
    && cd cairo-1.14.12  \
    && ./configure --enable-glesv2\
    && make \
    && make install \
    && rm -rf /tmp/* /var/tmp/*

# Install GLM
RUN cd /tmp \
    && git clone https://github.com/g-truc/glm.git -b 0.9.8 \
    && mkdir -p /tmp/glm/build \
    && cd /tmp/glm/build  \
    && cmake .. \
    && make \
    && make install \
    && rm -rf /tmp/* /var/tmp/*

# 
CMD [ "bash"]
