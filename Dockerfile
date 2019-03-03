# Start from Arch Linux.
FROM archlinux/base

# Author and image information.
LABEL maintainer="hrvoje.varga@gmail.com" \
      build="docker build -t hvarga/tuosde-docker ." \
      run="docker run --privileged --network host -it --rm -u $(id --user):$(id --group) -v $(pwd):/home/docker/project hvarga/tuosde-docker"

# Configure terminal to support 256 colors so that application can use more colors.
ENV TERM xterm-256color

# Update installed packages.
RUN pacman -Syu --noconfirm

# Install new packages.
RUN pacman -Sy --noconfirm \
	base-devel wget git	perl-authen-sasl perl-net-smtp-ssl perl-mime-tools zsh \
	htop mc asciinema tmux fzf task cloc jq rsync tree valgrind socat cgdb \
	calcurse gnu-netcat strace ltrace ckermit cmake ctags the_silver_searcher \
	upx openssh cscope shellcheck neovim python-neovim clang man-db man-pages \
	glances lsof wireshark-cli cmatrix nodejs cppcheck cmocka qemu-headless \
	qemu-headless-arch-extra gdb-dashboard python2 python2-setuptools

# Create user.
RUN groupadd sudo && \
	useradd -m -G sudo,wireshark -s /bin/zsh docker && \
	echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
	echo "Defaults:docker !authenticate" >> /etc/sudoers

# Switch user.
USER docker:docker

# Install yay AUR helper.
RUN cd /tmp && \
	git clone -q https://aur.archlinux.org/yay-bin.git && \
	cd yay-bin && \
	makepkg -si --noconfirm && \
	cd .. && \
	rm -fr /tmp/yay-bin

# Install packages from AUR.
RUN yay -S --noconfirm tmate ccls compiledb compiledb lcov python-gdbgui

# Install prezto.
COPY --chown=docker files/prezto_install /home/docker/prezto_install
RUN git clone -q --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" && \
	/bin/zsh -c "source ~/prezto_install" && \
	sed -ri "s/theme 'sorin'/theme 'skwp'/g" ~/.zpreztorc && \
	sed -ri "s/'prompt'/'prompt' 'syntax-highlighting' 'history-substring-search'/g" ~/.zpreztorc && \
	rm -rf ~/prezto_install

# Configure fzf.
RUN echo "source /usr/share/fzf/key-bindings.zsh" >> /home/docker/.zshrc && \
	echo "source /usr/share/fzf/completion.zsh" >> /home/docker/.zshrc && \
	echo "export FZF_DEFAULT_OPTS='--height 40% --reverse --border'" >> /home/docker/.zshrc

# Install neovim configuration.
RUN mkdir -p /home/docker/.config/nvim
COPY --chown=docker files/neovim_config /home/docker/.config/nvim/init.vim
COPY --chown=docker files/coc-settings.json /home/docker/.config/nvim/coc-settings.json

# Install neovim plugin manager.
RUN curl -sfLo /home/docker/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins.
RUN nvim +PlugInstall +UpdateRemotePlugins +qall &> /dev/null

# Configure neovim as a default system editor.
ENV EDITOR=nvim \
	VISUAL=nvim

# Install tmux configuration.
COPY --chown=docker files/tmux.conf /home/docker/.tmux.conf

# Install GDB configuration.
RUN cp /usr/share/gdb-dashboard/.gdbinit /home/docker/.gdb-dashboard

# Set working directory.
WORKDIR /home/docker

# Start ZSH.
CMD zsh
