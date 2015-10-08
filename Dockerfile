FROM ruby:2.2.0

# for timezone
RUN cp /usr/share/zoneinfo/Europe/Istanbul /etc/localtime

# for packages
RUN apt-get update -qq && apt-get install -y build-essential locales

# for MySQL
RUN apt-get install -y mysql-client libmysqlclient-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for a JS runtime
RUN apt-get install -y nodejs

RUN dpkg-reconfigure locales && \
	locale-gen C.UTF-8 && \
	/usr/sbin/update-locale LANG=C.UTF-8
ENV LC_ALL C.UTF-8

RUN rm -rf /usr/local/bundle/cache/

RUN groupadd -g 1000 user \
	&& useradd --create-home -d /home/user -g user -u 1000 user

RUN chown -R user:user /usr/local

RUN mkdir /app
RUN chown user:user /app

USER user

WORKDIR /app
ADD Gemfile /app/Gemfile
RUN bundle install
