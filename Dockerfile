# Start from Ubuntu image.
FROM ubuntu:20.04

# Author information.
LABEL maintainer="hrvoje.varga@gmail.com"

# Configure terminal to support 256 colors so that application can use more
# colors.
ENV TERM xterm-256color

# Install all other packages.
RUN apt-get update && yes | unminimize && DEBIAN_FRONTEND=noninteractive \
	apt-get install -y \
		ca-certificates curl apt-transport-https wget git-core unzip python \
		less man-db zsh asciinema htop tmux cloc tree openssh-client telnet \
		shellcheck lsof p7zip zip gettext neovim universal-ctags locales sudo \
		python3-neovim ripgrep sshpass global python3-virtualenv python3-dev \
		iputils-ping git-extras bitwise tmate inotify-tools rsync && \
	rm -rf /var/lib/apt/lists/*

# Configure system locale.
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8 \
	LANGUAGE=en_US:en \
	LC_ALL=en_US.UTF-8 \
	LC_CTYPE=en_US.UTF-8 \
	LC_MESSAGES=en_US.UTF-8 \
	LC_COLLATE=en_US.UTF-8

# Install sudoers configuration.
COPY files/sudoers /etc/sudoers.d/
RUN chmod 0440 /etc/sudoers.d/sudoers

# Install prezto.
RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git \
		/etc/zsh/prezto && \
	cd /etc/zsh/prezto; git checkout --detach 8a967fc && \
	echo "source /etc/zsh/prezto/runcoms/zlogin" > /etc/zsh/zlogin && \
	echo "source /etc/zsh/prezto/runcoms/zlogout" > /etc/zsh/zlogout && \
	echo "source /etc/zsh/prezto/runcoms/zshenv" > /etc/zsh/zshenv && \
	echo "source /etc/zsh/prezto/runcoms/zpreztorc" >> /etc/zsh/zshrc && \
	echo "source /etc/zsh/prezto/runcoms/zshrc" >> /etc/zsh/zshrc && \
	echo "source /etc/zsh/prezto/runcoms/zprofile" >> /etc/zsh/zprofile && \
	echo "ZPREZTODIR=/etc/zsh/prezto" >> "/etc/zsh/zshrc" && \
	echo "source \${ZPREZTODIR}/init.zsh" >> "/etc/zsh/zshrc" && \
	sed -ri "s/theme 'sorin'/theme 'skwp'/g" \
		/etc/zsh/prezto/runcoms/zpreztorc && \
	sed -ri '/directory/d' /etc/zsh/prezto/runcoms/zpreztorc && \
	sed -ri "s/'prompt'/'syntax-highlighting' \
		'history-substring-search' 'prompt'/g" /etc/zsh/prezto/runcoms/zpreztorc

# Configure Neovim as a default system editor.
RUN echo "export EDITOR=nvim" >> /etc/zsh/zshrc && \
	echo "export VISUAL=nvim" >> /etc/zsh/zshrc

# Install fzf.
RUN git clone --branch 0.23.1 --depth 1 https://github.com/junegunn/fzf.git \
		/tmp/fzf && \
	/tmp/fzf/install --bin && \
	cp /tmp/fzf/bin/* /usr/local/bin && \
	mkdir -p /usr/share/fzf/ && \
	cp /tmp/fzf/shell/*.zsh /usr/share/fzf/ && \
	cp /tmp/fzf/plugin/fzf.vim /usr/share/nvim/runtime/autoload && \
	rm -rf /tmp/fzf && \
	echo "source /usr/share/fzf/key-bindings.zsh" >> /etc/zsh/zshrc && \
	echo "source /usr/share/fzf/completion.zsh" >> /etc/zsh/zshrc && \
	echo "export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'" \
		>> /etc/zsh/zshrc && \
	echo "export FZF_DEFAULT_OPTS='--height 40% --reverse'" \
		>> /etc/zsh/zshrc

# Install Neovim plugin manager.
RUN mkdir -p /usr/share/nvim/runtime/autoload && \
	mkdir -p /usr/share/nvim/runtime/plugged && \
	curl -sfLo /usr/share/nvim/runtime/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install nnn.
RUN wget https://github.com/jarun/nnn/releases/download/v4.0/nnn_4.0-1_ubuntu20.04.amd64.deb \
	-O /tmp/nnn.deb && \
	dpkg -i /tmp/nnn.deb && \
	rm -rf /tmp/nnn.deb
ENV NNN_USE_EDITOR=1
RUN echo 'alias nnn="nnn -c -o"' >> /etc/zsh/zshrc

# Install Git LFS.
RUN wget https://packagecloud.io/github/git-lfs/packages/debian/buster/git-lfs_2.13.1_amd64.deb/download \
	-O /tmp/git-lfs.deb && \
	dpkg -i /tmp/git-lfs.deb && \
	rm -rf /tmp/git-lfs.deb

# Install neovim configuration.
COPY files/neovim_config /usr/share/nvim/sysinit.vim

# Install Neovim TUOSDE documentation.
COPY files/tuosde.txt /usr/share/nvim/runtime/doc/tuosde.txt
RUN nvim --headless -c "helptags ALL" +qall 2> /dev/null

# Install Neovim plugins.
RUN nvim --headless +PlugInstall +UpdateRemotePlugins +qall 2> /dev/null

# Install tmux configuration.
COPY files/tmux.conf /etc/tmux.conf

# Install tmux plugins.
RUN git clone \
		https://github.com/tmux-plugins/tpm /usr/share/tmux/plugins/tpm && \
	/usr/share/tmux/plugins/tpm/bin/install_plugins

# Install Git configuration.
COPY files/gitconfig /etc/gitconfig

# Install SSH configuration.
COPY files/ssh_config.conf /etc/ssh/ssh_config.d/

# Install entrypoint script.
COPY files/entrypoint.sh /usr/local/bin

# When a user gains access to shell he will be put into a workspace directory.
WORKDIR /opt/workspace

# Run entrypoint script.
ENTRYPOINT ["entrypoint.sh"]
