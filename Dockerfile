FROM tweekmonster/vim-testbed:latest

RUN install_vim \
      -tag v7.4.2119 -build \
      -tag v8.1.2000 -build \
      -tag neovim:v0.2.0 -build \
      -tag neovim:v0.3.8 -build

RUN apk --update add bash git python py-pip \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN pip install vim-vint==0.3.15

RUN git clone https://github.com/junegunn/vader.vim vader \
  && cd vader \
  && git checkout de8a976f1eae2c2b680604205c3e8b5c8882493c
