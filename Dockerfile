# Start from Arch Linux.
FROM archlinux/base

# Author and image information.
LABEL maintainer="hrvoje.varga@gmail.com" \
      build="docker build -t hvarga/tuosde-docker ." \
      run="docker run -it --rm hvarga/tuosde-docker"

# Configure terminal to support 256 colors so that application can use more colors.
ENV TERM xterm-256color

# Update installed packages.
RUN pacman -Syu --noconfirm

# Install new packages.
RUN pacman -Sy --noconfirm \
	base-devel \
	wget \
	git \
	perl-authen-sasl \
	perl-net-smtp-ssl \
	perl-mime-tools \
	zsh \
	htop \
	mc \
	asciinema \
	tmux \
	fzf \
	task \
	cloc \
	jq \
	rsync \
	tree \
	valgrind \
	socat \
	cgdb \
	calcurse \
	gnu-netcat \
	strace \
	ltrace \
	ckermit \
	cmake \
	ctags \
	the_silver_searcher \
	upx \
	openssh \
	cscope \
	shellcheck \
	neovim \
	xsel

# Install gentags.
COPY files/gentags /usr/local/bin/gentags

# Create and switch user.
RUN groupadd sudo && \
	useradd -m -G wheel -s /bin/zsh docker && \
	echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
	echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
	echo "Defaults:docker !authenticate" >> /etc/sudoers
USER docker

# Set the working directory.
WORKDIR /home/docker

# Install yay AUR helper.
RUN cd /tmp && \
	git clone -q https://aur.archlinux.org/yay-bin.git && \
	cd yay-bin && \
	makepkg -si --noconfirm && \
	cd .. && \
	rm -fr /tmp/yay-bin

# Install tmate.
RUN yay -S --noconfirm tmate

# Install rr.
RUN yay -S --noconfirm rr

# Install neovim configuration.
COPY files/vimrc /home/docker/.config/nvim/init.vim

# Install neovim plugin manager.
RUN curl -sfLo /home/docker/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins.
RUN nvim +'PlugInstall' +qall &> /dev/null

# Configure neovim as a default system editor.
ENV EDITOR=nvim \
	VISUAL=nvim

# Install tmux configuration.
COPY files/tmux.conf /home/docker/.tmux.conf

# Install prezto.
COPY files/prezto_install /home/docker/prezto_install
RUN git clone -q --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" && \
	/bin/zsh -c "source ~/prezto_install" && \
	sed -ri "s/theme 'sorin'/theme 'skwp'/g" ~/.zpreztorc && \
	sed -ri "s/'prompt'/'prompt' 'syntax-highlighting' 'history-substring-search'/g" ~/.zpreztorc && \
	rm -rf ~/prezto_install

# Configure fzf.
RUN echo "source /usr/share/fzf/key-bindings.zsh" >> /home/docker/.zshrc && \
	echo "source /usr/share/fzf/completion.zsh" >> /home/docker/.zshrc && \
	echo "export FZF_DEFAULT_OPTS='--height 40% --reverse --border'" >> /home/docker/.zshrc

# Start ZSH.
CMD zsh
