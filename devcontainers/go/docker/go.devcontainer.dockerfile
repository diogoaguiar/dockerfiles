FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install common tools
RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    ca-certificates \
    curl \
    wget \
    unzip \
    zip \
    vim \
    nano \
    sudo \
    locales \
    tzdata \
    gnupg \
    gnupg2 \
    gnupg1 \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Set timezone
ARG TZ=Europe/Lisbon
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

# Install git
RUN apt-get update && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/*

# Install Go
ARG GO_VERSION=1.21.6
RUN wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz
RUN echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc

# Install Node.js
ARG NODE_MAJOR=20
RUN curl -sL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Create developer user
ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/50-$USERNAME \
    && chmod 0440 /etc/sudoers.d/50-$USERNAME

# Install Starship
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y \
    && echo 'eval "$(starship init bash)"' >> /home/$USERNAME/.bashrc \
    && echo 'eval "$(starship init bash)"' >> /root/.bashrc

# Prepare Workspace
ARG WORKSPACE=/workspace
RUN mkdir -p ${WORKSPACE}
RUN chown ${USER_UID}:${USER_GID} ${WORKSPACE}
WORKDIR ${WORKSPACE}

# Run forever
ENTRYPOINT ["./docker/wait_forever.sh"]