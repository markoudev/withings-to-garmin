FROM alpine:3.13

RUN apk update && \
    apk upgrade && \
    apk add --no-cache bash ruby ruby-dev ruby-bundler build-base gcompat && \
    rm -rf /var/cache/apk/*

RUN wget https://chromedriver.storage.googleapis.com/89.0.4389.23/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver /bin && \
    rm chromedriver_linux64.zip

WORKDIR /app
COPY . .

RUN gem install bundler && \
    gem update --system && \
    bundle config set --local without 'development' && \
    bundle install

EXPOSE 4567

CMD ["bundle", "exec", "ruby", "app/web.rb"]
