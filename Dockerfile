FROM alpine:3.13

RUN apk update && \
    apk upgrade && \
    apk add --no-cache bash ruby ruby-dev ruby-bundler build-base && \
    rm -rf /var/cache/apk/*

WORKDIR /app
COPY . .

RUN gem install bundler && \
    gem update --system && \
    bundle config set --local without 'development' && \
    bundle install

EXPOSE 4567

CMD ["bundle", "exec", "ruby", "app/web.rb"]
