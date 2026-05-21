FROM ubuntu:22.04

ENV SSH_USER=admin \
    SSH_PASSWORD=Passw0rd! \
    GITHUB_USER=your_github_username

RUN apt-get update && apt-get install -y \
    openssh-server \
    curl \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

RUN useradd -m -s /bin/bash $SSH_USER && \
    echo "$SSH_USER:$SSH_PASSWORD" | chpasswd && \
    usermod -aG sudo $SSH_USER

RUN mkdir -p /home/$SSH_USER/.ssh && \
    chmod 700 /home/$SSH_USER/.ssh && \
    chown -R $SSH_USER:$SSH_USER /home/$SSH_USER/.ssh

RUN sed -i \
    -e 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' \
    -e 's/#PasswordAuthentication yes/PasswordAuthentication yes/' \
    -e 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' \
    -e 's|#AuthorizedKeysFile.*|AuthorizedKeysFile .ssh/authorized_keys|' \
    /etc/ssh/sshd_config

RUN echo "AuthorizedKeysFile .ssh/authorized_keys" >> /etc/ssh/ssh_config

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22 1194/udp

CMD ["/entrypoint.sh"]
