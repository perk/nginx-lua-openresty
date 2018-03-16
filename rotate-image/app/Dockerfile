FROM openresty/openresty:xenial

RUN apt-get update && apt-get install -y --no-install-recommends imagemagick libmagickwand-dev

RUN luarocks install magick
RUN luarocks install luafilesystem
