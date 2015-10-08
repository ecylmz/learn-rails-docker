FROM ecylmz/ruby-nginx:2.2.1

MAINTAINER Emre Can Yılmaz <emrecan@ecylmz.com>

# for timezone
RUN cp /usr/share/zoneinfo/Europe/Istanbul /etc/localtime

ENV RAILS_ENV production

RUN apt-get update && apt-get install -y cron

# Preinstall majority of gems
WORKDIR /tmp
COPY Gemfile /tmp/Gemfile
RUN bundle install

RUN mkdir /app
COPY docker/nginx-sites.conf /etc/nginx/sites-enabled/default
COPY docker/unicorn.rb /app/config/unicorn.rb
RUN cp /tmp/Gemfile.lock /app/Gemfile.lock
RUN mkdir /app/log
RUN mkdir /app/tmp
ADD . /app
WORKDIR /app

# unicorn log
RUN ln -sf /dev/stdout /app/log/unicorn_stdout.log
RUN ln -sf /dev/stderr /app/log/unicorn_stderr.log

VOLUME /app/log


RUN gem install foreman
CMD rm -f /app/tmp/unicorn.pid && foreman start -f Procfile

EXPOSE 80
