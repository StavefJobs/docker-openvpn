#!/bin/bash

if [ -n "$GITHUB_USER" ] && [ "$GITHUB_USER" != "your_github_username" ]; then
    curl -fsSL "https://raw.githubusercontent.com/$GITHUB_USER/main/my.keys" \
      -o /home/$SSH_USER/.ssh/authorized_keys 2>/dev/null && \
    chmod 600 /home/$SSH_USER/.ssh/authorized_keys && \
    chown $SSH_USER:$SSH_USER /home/$SSH_USER/.ssh/authorized_keys
fi

exec /usr/sbin/sshd -D
