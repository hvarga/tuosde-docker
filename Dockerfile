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
		ca-certificates curl apt-transport-https build-essential wget git-core \
		unzip python less man-db zsh asciinema htop tmux cloc tree valgrind \
		strace tmuxinator openssh-client shellcheck lsof libcmocka0 doxygen \
		p7zip zip lcov gosu gettext libtool libtool-bin autoconf automake \
		pkg-config cmake clang libclang-dev neovim universal-ctags telnet \
		python3-neovim ripgrep locales sshpass global sudo python3-virtualenv \
		python3-dev clang-tidy gcc-multilib clang-format git-extras bitwise && \
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

# Configure Neovim as a default system editor.
ENV EDITOR=nvim \
	VISUAL=nvim

# Install prezto.
RUN	git clone --recursive https://github.com/sorin-ionescu/prezto.git \
		/etc/zsh/prezto && \
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
	echo "export FZF_DEFAULT_OPTS='--height 40% --reverse --border'" \
		>> /etc/zsh/zshrc

# Install Neovim plugin manager.
RUN mkdir -p /usr/share/nvim/runtime/autoload && \
	mkdir -p /usr/share/nvim/runtime/plugged && \
	curl -sfLo /usr/share/nvim/runtime/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install Go.
RUN curl -SsL \
		https://dl.google.com/go/go1.15.2.linux-amd64.tar.gz \
		-o /tmp/go.tar.gz && \
	tar -C /usr/local -xzf /tmp/go.tar.gz && \
	rm -rf /tmp/go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

# Install Ericsson CodeChecker.
RUN git clone https://github.com/Ericsson/CodeChecker.git \
                /opt/codechecker && \
        cd /opt/codechecker && \
        git checkout --detach 65aa0c90a4f5d8a1d857e4ef1570045419c65266 && \
        make venv && \
        . venv/bin/activate && \
        make package
COPY files/codechecker.sh /usr/local/bin/CodeChecker

# Install Trilium.
RUN wget https://github.com/zadam/trilium/releases/download/v0.44.9/trilium-linux-x64-server-0.44.9.tar.xz \
		-O /tmp/trilium.tar.xz && \
	cd /tmp && \
	tar -xf /tmp/trilium.tar.xz && \
	mv trilium-linux-x64-server /opt/trilium && \
	rm -rf /tmp/trilium.tar.xz
COPY files/trilium.sh /opt/trilium
ENV PATH="/opt/trilium:${PATH}"
ENV TRILIUM_DATA_DIR=/opt/data/trilium

# Install nnn.
RUN wget https://github.com/jarun/nnn/releases/download/v3.5/nnn_3.5-1_ubuntu20.04.amd64.deb \
	-O /tmp/nnn.deb && \
    dpkg -i /tmp/nnn.deb && \
    rm -rf /tmp/nnn.deb
ENV NNN_USE_EDITOR=1
RUN echo 'alias nnn="nnn -c"' >> /etc/zsh/zshrc

# Install neovim configuration.
COPY files/neovim_config /usr/share/nvim/sysinit.vim

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

# Install entrypoint script.
COPY files/entrypoint.sh /usr/local/bin

# When a user gains access to shell he will be put into a workspace directory.
WORKDIR /opt/workspace

# Run entrypoint script.
ENTRYPOINT ["entrypoint.sh"]
