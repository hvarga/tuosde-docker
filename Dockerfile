# Start from Ubuntu image.
FROM ubuntu:20.04

# Author information.
LABEL maintainer="hrvoje.varga@gmail.com"

# Configure terminal to support 256 colors so that application can use more
# colors.
ENV TERM xterm-256color

# Install core packages.
RUN apt-get update && yes | unminimize && DEBIAN_FRONTEND=noninteractive \
	apt-get install -y \
		ca-certificates curl apt-transport-https wget unzip python less man-db \
		zsh asciinema htop tmux tree openssh-client telnet w3m make p7zip zip \
		universal-ctags locales sudo rsync ncat python3-neovim python3-dev \
		iputils-ping bitwise build-essential software-properties-common && \
	rm -rf /var/lib/apt/lists/*

# Add PPA repositories.
RUN add-apt-repository ppa:git-core/ppa

# Install packages from PPA repositories.
RUN apt-get update && yes | unminimize && DEBIAN_FRONTEND=noninteractive \
	apt-get install -y \
		git-core git-extras && \
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

# Install Neovim.
# FIXME: Plugin man.vim is, for some reason, installed, even though it is not
# part of Neovim package. This plugin MUST not be installed as it is not
# compatible with Neovim. This is even checked by Neovim using :checkhealth.
# There should be a better way to remove this plugin but, for the time being,
# this is done manually.
RUN wget https://github.com/neovim/neovim/releases/download/v0.8.1/nvim-linux64.tar.gz \
		-O /tmp/nvim.tar.gz && \
	tar xzvf /tmp/nvim.tar.gz -C /tmp/ && \
	cp -r /tmp/nvim-linux64/* /usr && \
	rm -rf /tmp/nvim.tar.gz && \
	rm -rf /lib/nvim/parser && \
	rm -rf /usr/share/nvim/runtime/plugin/man.vim && \
	rm -rf /usr/share/nvim/runtime/autoload/man.vim

# Configure Neovim as a default system editor.
RUN echo "export EDITOR=nvim" >> /etc/zsh/zshrc && \
	echo "export VISUAL=nvim" >> /etc/zsh/zshrc

# Install ShellCheck.
RUN wget https://github.com/koalaman/shellcheck/releases/download/v0.8.0/shellcheck-v0.8.0.linux.x86_64.tar.xz \
		-O /tmp/shellcheck.tar.xz && \
	tar xvf /tmp/shellcheck.tar.xz -C /tmp/ && \
	mv /tmp/shellcheck-v0.8.0/shellcheck /usr/bin/shellcheck && \
	rm -rf /tmp/shellcheck.tar.xz /tmp/shellcheck-v0.8.0

# Install fzf.
RUN git clone --branch 0.35.1 --depth 1 https://github.com/junegunn/fzf.git \
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
RUN wget https://github.com/jarun/nnn/releases/download/v4.7/nnn-musl-static-4.7.x86_64.tar.gz \
		-O /tmp/nnn.tar.gz && \
	tar xvf /tmp/nnn.tar.gz -C /tmp/ && \
	mv /tmp/nnn-musl-static /usr/bin/nnn && \
	rm -rf /tmp/nnn.tar.gz
ENV NNN_USE_EDITOR=1

# Install Git LFS.
RUN wget https://packagecloud.io/github/git-lfs/packages/debian/buster/git-lfs_2.13.1_amd64.deb/download \
		-O /tmp/git-lfs.deb && \
	dpkg -i /tmp/git-lfs.deb && \
	rm -rf /tmp/git-lfs.deb

# Install fd.
RUN wget https://github.com/sharkdp/fd/releases/download/v8.5.2/fd-musl_8.5.2_amd64.deb \
		-O /tmp/fd.deb && \
	dpkg -i /tmp/fd.deb && \
	rm -rf /tmp/fd.deb

# Install ripgrep.
RUN wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb \
		-O /tmp/ripgrep.deb && \
	dpkg -i /tmp/ripgrep.deb && \
	rm -rf /tmp/ripgrep.deb

# Install Neovim configuration.
COPY files/config.vim /usr/share/nvim/sysinit.vim

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
