FROM ruby:alpine

EXPOSE 3000

RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      openssl \
      pkgconfig \
      tzdata \
      sqlite-dev \
      nodejs \
      postgresql \
      postgresql-dev \
      imagemagick

RUN gem install bundler
# -v 2.2.3

WORKDIR /app

COPY . ./

RUN bundle install

RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]
