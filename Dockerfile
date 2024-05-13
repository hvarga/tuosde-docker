# Start from official Alpine Linux image.
FROM alpine:3.19

# Set default shell.
ENV SHELL "/usr/bin/fish"
ENV EDITOR "hx"
ENV TERM "xterm-256color"
ENV COLORTERM "truecolor"

# Install packages.
RUN \
  apk add --no-cache \
    less man-db fish bash asciinema tree bitwise shellcheck nnn git-lfs fd \
    ripgrep docs gitui helix delta zellij bat skim dust tree-sitter-grammars \
    g++ openssh-client-default

# Copy configuration files into image.
COPY config/* /etc/config/

# Copy container entrypoint into image.
COPY entrypoint.sh /usr/bin

# Copy container commands into image.
ENV TUOSDE_CMDS_PATH=/usr/bin/cmds
COPY cmd/* ${TUOSDE_CMDS_PATH}/
ENV PATH="${PATH}:${TUOSDE_CMDS_PATH}"

# When a user gains access to shell he will be put into a workspace directory.
WORKDIR /opt/workspace

# Run a terminal multiplexor as a first process.
ENTRYPOINT ["entrypoint.sh"]
CMD ["workspace"]
