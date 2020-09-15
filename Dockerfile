FROM ruby:2-alpine

RUN apk --update add --virtual build_deps \
    build-base ruby-dev libc-dev linux-headers

RUN apk add git \
  && mkdir -p /usr/src/app 

WORKDIR /usr/src/app

ENV GITHUB_GEM_VERSION=207
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundler install 

COPY . .

EXPOSE 8080
ENTRYPOINT [ "rake" ]
CMD run