FROM debian:bookworm-20231120-slim

ARG VERSION=

RUN apt-get -y update \
  && apt-get -y install --no-install-recommends wget ca-certificates xz-utils git \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN wget https://ziglang.org/builds/zig-linux-x86_64-${VERSION}.tar.xz \
  && tar -xf zig-linux-x86_64-${VERSION}.tar.xz \
  && mv zig-linux-x86_64-${VERSION}/* /usr/local/bin \
  && git clone https://github.com/zigtools/zls \
  && cd zls \
  && zig build -Doptimize=ReleaseSafe \
  && mv zig-out/bin/zls /usr/local/bin \
  && rm -rf /opt/zig-linux-x86_64-${VERSION}.tar.xz \
  && rm -rf /opt/zls