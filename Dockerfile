FROM tweekmonster/vim-testbed:latest

RUN install_vim \
      -tag v8.0.1630 -build \
      -tag v8.1.1511 -build \
      -tag neovim:v0.3.2 -build

ENV PACKAGES="bash git python py-pip"

RUN apk --update add $PACKAGES \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN pip install vim-vint==0.3.15

RUN git clone https://github.com/junegunn/vader.vim vader \
  && cd vader \
  && git checkout de8a976f1eae2c2b680604205c3e8b5c8882493c
