FROM  node:12.16.1
LABEL author="DK"

ENV DEBIAN_FRONTEND noninteractive

USER root
WORKDIR /
RUN apt-get update  \ 
    && apt-get -yq upgrade \
    && apt-get install -yq --no-install-recommends \
    acl \
    apt-transport-https \
    apt-utils \
    bzip2 \
    ca-certificates \
    chromium \
    cmake \
    curl \
    encfs \
    fontconfig \
    fonts-liberation \
    gconf-service \
    gdebi \
    git \
    htop \
    imagemagick \
    libappindicator1 \
    libappindicator3-1 \
    libasound2 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    libhdf5-dev\
    libncurses5-dev \
    libncursesw5-dev \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    locales \
    lsb-release \
    mc \
    nano \
    ninja-build \
    openssh-server build-essential \
    parallel \
    screen \
    sudo \
    systemd \
    unzip \
    vim \
    wget \
    wget \
    tmux \
    xdg-utils \
    zsh \
    && rm -rf /var/lib/apt/lists/* && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen \
    && npm install -g @angular/cli

# RUN groupadd -g 1001 node \
RUN useradd -m -g node -s /bin/bash -N dev \
    && echo 'dev ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && echo dev:dev | chpasswd 
# && mkdir /home/dev/projects \
# && chown -R dev:1001 /home/dev/projects


USER dev
WORKDIR /home/dev/
    COPY bash/bash.git /tmp/bash.git
    COPY bash/bash.alias /tmp/bash.alias
    RUN git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt --depth=1 \
        && cat /tmp/bash.git >> /home/dev/.bashrc \
        && cat /tmp/bash.alias >> /home/dev/.bashrc

USER root
    RUN mkdir /dep
    COPY --chown=root:node  script /script
    COPY --chown=root:node  packages/google-chrome-stable_current_amd64.deb /dep
    RUN chmod -R ug+rwx /script
    WORKDIR /dep
    RUN dpkg -i google-chrome-stable_current_amd64.deb
    RUN apt-get -yq install -f


RUN mkdir /var/run/sshd \
    && apt-get -yq autoremove \
    && apt-get clean 


EXPOSE 22
# Entrypoint
ENTRYPOINT ["/bin/bash"]
CMD ["/script/start"]