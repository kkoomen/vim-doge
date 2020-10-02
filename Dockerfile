FROM tweekmonster/vim-testbed:latest

RUN install_vim -tag v7.4.2119 -py3 -build
RUN install_vim -tag v8.1.2300 -py3 -build
RUN install_vim -tag neovim:v0.2.0 -py3 -build
RUN install_vim -tag neovim:v0.4.3 -py3 -build

# Install base dependencies.
RUN apk -v --progress add --no-cache bash git

# Install NodeJS.
RUN apk --no-cache add g++ gcc libgcc libstdc++ linux-headers make python
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community nodejs nodejs-npm
RUN npm install -g node-gyp

ENV NODE_PATH="/usr/lib/node_modules"
RUN npm -g config set user root
RUN npm install -g tree-sitter \
      tree-sitter-typescript \
      tree-sitter-php

# Install addition python modules.
RUN pip3 install --upgrade pip vim-vint==0.3.15 setuptools

# Cleanup.
RUN rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Install Vader.
RUN git clone https://github.com/junegunn/vader.vim vader \
  && cd vader \
  && git checkout de8a976f1eae2c2b680604205c3e8b5c8882493c

CMD ["/bin/bash"]
