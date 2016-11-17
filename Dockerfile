FROM ubuntu:latest

# apt-gets
RUN apt-get update
RUN apt-get install -y curl git nano less bash git bash-completion
RUN apt-get install -y apache2 mariadb-server imagemagick
RUN apt-get install -y php7.0*
RUN apt-get remove -y  php7.0-snmp 
RUN apt-get install -y libapache2-mod-php7.0 pkg-config libmagickwand-dev libmagickcore-dev mcrypt supervisor

# custom installs
RUN curl -o /usr/bin/original_wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x /usr/bin/original_wp
RUN echo "/usr/bin/original_wp --allow-root \"\$@\"" > /usr/bin/wp
RUN chmod +x /usr/bin/wp
RUN alias wp='wp --allow-root'

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# create some structure and modify permissions
RUN mkdir /dump
RUN chmod 777 -R /dump
RUN chmod 777 -R /var/www/html


# some final configurations
RUN rm /var/www/html/index.html

COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /var/www/html/

ENV TERM xterm

EXPOSE 80 443 3306

# prep init
COPY init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh
CMD ["init.sh"]
