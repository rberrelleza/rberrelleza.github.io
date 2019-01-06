FROM ruby:2.3-alpine

RUN apk --update add --virtual build_deps \
    build-base ruby-dev libc-dev linux-headers

RUN apk add git \
  && mkdir -p /usr/src/app 

ENV GITHUB_GEM_VERSION=193
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundler install 

WORKDIR /usr/src/app

EXPOSE 4000 80
ENTRYPOINT [ "rake" ]
CMD run