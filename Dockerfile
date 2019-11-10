FROM tweekmonster/vim-testbed:latest

RUN install_vim \
      -tag v7.4.2119 -build \
      -tag v8.1.2000 -py3 -build \
      -tag neovim:v0.2.0 -py3 -build \
      -tag neovim:v0.3.8 -py3 -build

# Install base dependencies.
RUN apk -v --progress add bash git
RUN apk -v --progress add clang=8.0.0-r0

# Install Python3
RUN apk -v --progress add --virtual .build-deps g++ python3-dev libffi-dev openssl-dev
RUN apk -v --progress add python3

# Install addition python modules.
RUN pip3 install --upgrade pip vim-vint==0.3.15 clang setuptools

# Create a symlink to our libclang binary.
RUN ln -s /usr/lib/libclang.so.8 /usr/lib/libclang.so

# Remove unnecessary files.
RUN rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Install Vader.
RUN git clone https://github.com/junegunn/vader.vim vader \
  && cd vader \
  && git checkout de8a976f1eae2c2b680604205c3e8b5c8882493c

CMD ["/bin/bash"]
