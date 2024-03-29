# Start with Ubuntu base image
FROM ubuntu:18.04
MAINTAINER Yongbin Gu <@gyb1325>

# Install wget and build-essential
RUN apt-get update && apt-get install -y \
  build-essential \
  module-init-tools \
  wget

# Change to the /tmp directory
RUN cd /tmp && \
# Download run file
  wget http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run && \
# Make the run file executable and extract
  chmod +x cuda_*_linux.run && ./cuda_*_linux.run -extract=`pwd` && \
# Install CUDA drivers (silent, no kernel)
  ./NVIDIA-Linux-x86_64-*.run -s --no-kernel-module && \
# Install toolkit (silent)  
  ./cuda-linux64-rel-*.run -noprompt && \
# Clean up
  rm -rf *

# Add to path
ENV PATH=/usr/local/cuda/bin:$PATH \
  LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Install cuDNN
RUN apt-get install -y rsync
WORKDIR /home
ADD cudnn-7.0-linux-x64-v3.0-prod.tgz /home
RUN ls -la
RUN rsync -a cuda/ /usr/local/cuda/
RUN rm -rf cuda
