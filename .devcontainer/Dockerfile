# Use official Debian base image
FROM mcr.microsoft.com/devcontainers/base:debian

# Set environment variables
ENV FLUTTER_HOME=/home/vscode/flutter \
    PATH="${PATH}:/home/vscode/flutter/bin:/home/vscode/flutter/bin/cache/dart-sdk/bin"

# Install dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        curl \
        git \
        unzip \
        xz-utils \
        zip \
        libglu1-mesa \
        clang \
        cmake \
        ninja-build \
        pkg-config \
        libgtk-3-dev \
        liblzma-dev \
        libstdc++-12-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Switch to vscode user for Flutter installation
USER vscode
WORKDIR /home/vscode

# Download and install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 ${FLUTTER_HOME} \
    && flutter precache \
    && flutter config --no-analytics \
    && flutter --version

# Pre-download Flutter artifacts for faster startup
RUN flutter precache --linux

# Switch back to root for any additional setup
USER root

# Set working directory to workspace
WORKDIR /workspaces

# Switch back to vscode user
USER vscode
