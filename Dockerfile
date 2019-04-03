# Start from Arch Linux.
FROM archlinux/base

# Author information.
LABEL maintainer="hrvoje.varga@gmail.com"

# Configure terminal to support 256 colors so that application can use more colors.
ENV TERM xterm-256color

# Update installed packages and install new packages.
RUN pacman -Syu --noconfirm && pacman -Sy --noconfirm \
	base-devel wget git	perl-authen-sasl perl-net-smtp-ssl perl-mime-tools zsh \
	htop mc asciinema tmux fzf task cloc jq rsync tree valgrind socat cgdb \
	calcurse gnu-netcat strace ltrace ckermit cmake ctags the_silver_searcher \
	upx openssh cscope shellcheck neovim python-neovim clang man-db man-pages \
	glances lsof wireshark-cli cmatrix nodejs cppcheck cmocka qemu-headless \
	qemu-headless-arch-extra gdb-dashboard python2 python2-setuptools rapidjson \
	bat ranger doxygen graphviz p7zip unrar zip unzip

# Configure user nobody and sudo privileges.
RUN	groupadd sudo && \
	echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
	echo "Defaults:docker !authenticate" >> /etc/sudoers && \
	echo "nobody ALL=(ALL) ALL" >> /etc/sudoers && \
    echo "Defaults:nobody !authenticate" >> /etc/sudoers && \
	mkdir /home/build && \
	chgrp nobody /home/build && \
	chmod g+ws /home/build && \
	setfacl -m u::rwx,g::rwx /home/build && \
	setfacl -d --set u::rwx,g::rwx,o::- /home/build

ENV HOME /home/build

# Switch to user nobody to be able to install AUR packages.
USER nobody:nobody

# Install yay AUR helper.
WORKDIR /home/build
RUN git clone -q https://aur.archlinux.org/yay-bin.git && \
	cd yay-bin && \
	makepkg -si --noconfirm && \
	cd .. && \
	rm -fr yay-bin

# Install packages from AUR.
RUN yay -S --noconfirm tmate ccls compiledb compiledb lcov python-gdbgui prezto-git tmuxinator

USER root:root

# Configure fzf.
RUN echo "source /usr/share/fzf/key-bindings.zsh" >> /etc/zsh/zshrc && \
	echo "source /usr/share/fzf/completion.zsh" >> /etc/zsh/zshrc && \
	echo "export FZF_DEFAULT_OPTS='--height 40% --reverse --border'" >> /etc/zsh/zshrc

# Install neovim plugin manager.
RUN mkdir -p /usr/share/nvim/autoload && \
	mkdir -p /usr/share/nvim/plugged && \
	curl -sfLo /usr/share/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Configure neovim as a default system editor.
ENV EDITOR=nvim \
	VISUAL=nvim

# Install tmux configuration.
COPY files/tmux.conf /etc/tmux.conf

# Fix compiledb warnings.
RUN sudo compiledb --help &> /dev/null

# Configure prezto.
RUN sed -ri "s/theme 'sorin'/theme 'skwp'/g" /usr/lib/prezto/runcoms/zpreztorc && \
	sed -ri "s/'prompt'/'prompt' 'syntax-highlighting' 'history-substring-search'/g" /usr/lib/prezto/runcoms/zpreztorc

# Install gosu.
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64" && \
	chmod +x /usr/local/bin/gosu

# Install neovim configuration.
COPY files/neovim_config /usr/share/nvim/sysinit.vim

# Install neovim plugins.
RUN nvim +PlugInstall +UpdateRemotePlugins +qall &> /dev/null && \
	find /usr/share/nvim/plugged -type d ! -wholename "*/.git*" -exec chmod o+rx {} \; && \
	find /usr/share/nvim/plugged -type f ! -wholename "*/.git*" -exec chmod o+r {} \;

# Install entrypoint script.
COPY files/entrypoint.sh /usr/local/bin

# When a user gains access to shell he will be put into a workspace directory.
WORKDIR /opt/workspace

# Run entrypoint script.
ENTRYPOINT ["entrypoint.sh"]
