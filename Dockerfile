# Start from minimal Debian image.
FROM debian:buster-slim

# Author information.
LABEL maintainer="hrvoje.varga@gmail.com"

# Configure terminal to support 256 colors so that application can use more
# colors.
ENV TERM xterm-256color

# Install all other packages.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		curl apt-transport-https build-essential wget git-core unzip socat \
		python less man-db zsh tmate asciinema graphviz jq htop mc tmux cloc \
		rsync tree valgrind cgdb calcurse netcat strace ltrace tmuxinator \
		silversearcher-ag upx openssh-client cscope shellcheck glances lsof \
		tshark cmatrix nodejs cppcheck libcmocka0 qemu qemu-system \
		rapidjson-dev ranger doxygen p7zip zip lcov gosu ninja-build gettext \
		libtool libtool-bin autoconf automake pkg-config cmake clang \
		libclang-dev neovim universal-ctags bear python-neovim ripgrep \
		texlive-full && \
	rm -rf /var/lib/apt/lists/*

# Configure Neovim as a default system editor.
ENV EDITOR=nvim \
	VISUAL=nvim

# Install ccls.
RUN git clone --depth=1 --recursive https://github.com/MaskRay/ccls \
		/tmp/ccls && \
	cd /tmp/ccls && \
	cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release && \
	cmake --build Release && \
	cp Release/ccls /usr/bin && \
	rm -rf /tmp/ccls

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
	sed -ri "s/'prompt'/'prompt' 'syntax-highlighting' \
		'history-substring-search'/g" /etc/zsh/prezto/runcoms/zpreztorc

# Install fzf.
RUN git clone --branch 0.18.0 --depth 1 https://github.com/junegunn/fzf.git \
		/tmp/fzf && \
	/tmp/fzf/install --bin && \
	cp /tmp/fzf/bin/* /usr/local/bin && \
	mkdir -p /usr/share/fzf/ && \
	cp /tmp/fzf/shell/*.zsh /usr/share/fzf/ && \
	cp /tmp/fzf/plugin/fzf.vim /usr/share/nvim/runtime/autoload && \
	rm -rf /tmp/fzf && \
	echo "source /usr/share/fzf/key-bindings.zsh" >> /etc/zsh/zshrc && \
	echo "source /usr/share/fzf/completion.zsh" >> /etc/zsh/zshrc && \
	echo "export FZF_DEFAULT_OPTS='--height 40% --reverse --border'" \
		>> /etc/zsh/zshrc

# Install Neovim plugin manager.
RUN mkdir -p /usr/share/nvim/runtime/autoload && \
	mkdir -p /usr/share/nvim/runtime/plugged && \
	curl -sfLo /usr/share/nvim/runtime/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install neovim configuration.
COPY files/neovim_config /usr/share/nvim/sysinit.vim

# Install Neovim plugins.
RUN nvim --headless +PlugInstall +UpdateRemotePlugins +qall 2> /dev/null

# Install tmux configuration.
COPY files/tmux.conf /etc/tmux.conf

# Install entrypoint script.
COPY files/entrypoint.sh /usr/local/bin

# When a user gains access to shell he will be put into a workspace directory.
WORKDIR /opt/workspace

# Run entrypoint script.
ENTRYPOINT ["entrypoint.sh"]
