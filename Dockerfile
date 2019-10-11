FROM alpine:3.9

LABEL maintainer "Michael Molchanov <mmolchanov@adyax.com>"

USER root

# SSH config.
RUN mkdir -p /root/.ssh
ADD config/ssh /root/.ssh/config
RUN chown root:root /root/.ssh/config && chmod 600 /root/.ssh/config

# Install base.
RUN apk add --update --no-cache \
  autoconf \
  automake \
  bash \
  build-base \
  bzip2 \
  ca-certificates \
  curl \
  freetype \
  fuse \
  git \
  git-lfs \
  grep \
  gzip \
  jq \
  libbz2 \
  libffi \
  libffi-dev \
  libjpeg-turbo \
  libmcrypt \
  libpq \
  libpng \
  libxml2 \
  libxslt \
  libzip \
  make \
  mysql-client \
  openssh \
  libressl \
  libressl-dev \
  patch \
  procps \
  postgresql-client \
  python \
  py-crcmod \
  py-pip \
  rsync \
  sqlite \
  strace \
  tar \
  unzip \
  wget \
  zlib \
  && rm -rf /var/lib/apt/lists/* \
  && pip install yq requests

COPY --from=hairyhenderson/gomplate:v3.1.0-slim /gomplate /bin/gomplate

# Install goofys
ENV GOOFYS_VERSION 0.19.0
RUN curl --fail -sSL -o goofys https://github.com/kahing/goofys/releases/download/v${GOOFYS_VERSION}/goofys \
  && mv goofys /usr/local/bin/ \
  && chmod +x /usr/local/bin/goofys \
  && mkdir /lib64 \
  && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2


# Install fd
ENV FD_VERSION 7.3.0
RUN curl --fail -sSL -o fd.tar.gz https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-v${FD_VERSION}-x86_64-unknown-linux-musl.tar.gz \
  && tar -zxf fd.tar.gz \
  && cp fd-v${FD_VERSION}-x86_64-unknown-linux-musl/fd /usr/local/bin/ \
  && rm -f fd.tar.gz \
  && rm -fR fd-v${FD_VERSION}-x86_64-unknown-linux-musl \
  && chmod +x /usr/local/bin/fd

# Install variant
ENV VARIANT_VERSION 0.36.4
RUN curl --fail -sSL -o variant.tar.gz https://github.com/mumoshu/variant/releases/download/v${VARIANT_VERSION}/variant_${VARIANT_VERSION}_linux_amd64.tar.gz \
    && mkdir -p variant \
    && tar -zxf variant.tar.gz -C variant \
    && cp variant/variant /usr/local/bin/ \
    && rm -f variant.tar.gz \
    && rm -fR variant \
    && chmod +x /usr/local/bin/variant

# Install nodejs and grunt.
RUN apk add --update --no-cache libuv nodejs nodejs-npm nodejs-dev yarn \
  && rm -rf /var/cache/apk/* \
  && npm install -g gulp-cli grunt-cli bower \
  && node --version \
  && npm --version \
  && grunt --version \
  && gulp --version \
  && bower --version \
  && yarn versions

