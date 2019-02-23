# Start from minimal Alpine Linux 3.9.
FROM alpine:3.9

# Author and image information.
LABEL maintainer="hrvoje.varga@gmail.com" \
      build="docker build -t hvarga/tuosde-docker ." \
      run="docker run -it --rm hvarga/tuosde-docker"

ENV TERM xterm-256color

# Add testing repository as there are packages that only found there.
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Install packages.
RUN apk add \
    build-base \
    vim \
	wget \
	git \
	zsh \
	htop \
	mc \
	asciinema \
	tmux \
	fzf \
	fzf-zsh-completion \
	fzf-tmux \
	task \
	cloc \
	jq \
	rsync \
	tree \
	valgrind \
	socat \
	cgdb \
	calcurse \
	netcat-openbsd \
	strace \
	ltrace \
	ckermit \
	cmake \
	curl \
	ctags \
	the_silver_searcher \
	upx \
	openssh \
	cscope@testing

# Install Vim configuration.
COPY files/vimrc /root/.vimrc

# Install Vim plugin manager.
RUN curl -sfLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins.
RUN vim +'PlugInstall' +qall &> /dev/null

# Install ShellCheck.
RUN curl -SsL https://storage.googleapis.com/shellcheck/shellcheck-latest.linux.x86_64.tar.xz -o /tmp/shellcheck.tar.xz && \
    tar xvf /tmp/shellcheck.tar.xz -C /tmp && \
    cp /tmp/shellcheck-latest/shellcheck /usr/local/bin/shellcheck && \
    rm -rf /tmp/shellcheck.tar.xz && \
    rm -rf /tmp/shellcheck-latest

# Configure Vim as a default system editor.
ENV EDITOR=vim \
	VISUAL=vim

# Install tmux configuration.
COPY files/tmux.conf  /root/.tmux.conf

# Install prezto.
COPY files/prezto_install /root/prezto_install
RUN git clone -q --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" && \
	/bin/zsh -c "source /root/prezto_install" && \
	echo "unalias ls" >> /root/.zshrc && \
	echo "unalias grep" >> /root/.zshrc && \
	sed -ri "s/theme 'sorin'/theme 'skwp'/g" /root/.zpreztorc && \
	sed -ri "s/'prompt'/'prompt' 'syntax-highlighting' 'history-substring-search'/g" /root/.zpreztorc && \
	rm -rf /root/prezto_install

# Configure fzf.
RUN echo "source /usr/share/fzf/key-bindings.zsh" >> /root/.zshrc && \
	echo "source /usr/share/zsh/site-functions/_fzf" >> /root/.zshrc

# Install gentags.
COPY files/gentags /usr/local/bin/gentags

# Set the working directory.
WORKDIR /root

# Start ZSH.
CMD zsh
