FROM debian:stable-slim
LABEL maintainer "Luiz Gavaza <gavaza@gmail.com>"
ARG USERNAME
ARG uid

RUN mkdir -p /opt/warsaw && touch /opt/warsaw/warsaw.sh \
    && echo "#!/bin/bash" >> /opt/warsaw/warsaw.sh \
    && echo "sudo /etc/init.d/warsaw start" >> /opt/warsaw/warsaw.sh \
    && echo "/usr/local/bin/warsaw/core" >> /opt/warsaw/warsaw.sh \
    && echo "firefox --display=\$DISPLAY --no-remote --private-window" >> /opt/warsaw/warsaw.sh \
    && echo "sudo /etc/init.d/warsaw stop" >> /opt/warsaw/warsaw.sh \
    && chmod 755 /opt/warsaw/warsaw.sh \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y full-upgrade \
    && apt-get -y install --no-install-recommends \
    wget ca-certificates \
    firefox-esr firefox-esr-l10n-pt-br libcanberra-gtk3-module \
    sudo \
    && wget -c https://cloud.gastecnologia.com.br/gas/diagnostico/warsaw_setup_64.deb \
    && apt-get -y install --no-install-recommends ./warsaw_setup_64.deb \
    && rm warsaw_setup_64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g $uid $USERNAME \
    && useradd -u $uid -r -g $USERNAME -G audio,video $USERNAME \
    && mkdir -p /home/$USERNAME \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME \
    && echo "$USERNAME:$USERNAME" | chpasswd \
    && usermod --shell /bin/bash $USERNAME \
    # Replace your user/group id
    && echo "%$USERNAME ALL=(ALL) NOPASSWD: /etc/init.d/warsaw" >> /etc/sudoers.d/warsaw \
    && echo "%$USERNAME ALL=(ALL) NOPASSWD: /usr/local/bin/warsaw/core" >> /etc/sudoers.d/warsaw \
    && chmod 0440 /etc/sudoers.d/warsaw

ENTRYPOINT ["/opt/warsaw/warsaw.sh"]
