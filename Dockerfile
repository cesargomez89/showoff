# syntax = docker/dockerfile:1
FROM ruby:4.0.0-slim
ARG RAILS_MASTER_KEY

WORKDIR /app

ENV RAILS_ENV="development" \
  BUNDLE_PATH="/usr/local/bundle" \
  RUBY_ZJIT_ENABLE=1

RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential \
  libyaml-dev imagemagick vim exiv2 curl git cmake \
  libpq-dev postgresql-client libvips pkg-config && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
