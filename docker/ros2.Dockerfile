FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive

RUN echo "root:toor" | chpasswd

ARG USERNAME=v
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt update \
    && apt install -y build-essential git strace cmake mc nmap gdb \
    #
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support for non-root user
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME 

RUN sudo apt install locales \
     && sudo locale-gen en_US en_US.UTF-8 \
     && sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
     && export LANG=en_US.UTF-8

RUN sudo apt install -y curl gnupg2 lsb-release \
     && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

RUN sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'

RUN sudo apt update && apt install -y ros-foxy-desktop


RUN sudo apt install tmux
    # Clean up
RUN apt-get autoremove -y \
   && apt-get clean -y \
   && rm -rf /var/lib/apt/lists/*
