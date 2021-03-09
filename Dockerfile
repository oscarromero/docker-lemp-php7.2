# Base Image to start building the stack
FROM oromero87/php7.2-memcached as base
WORKDIR /tmp

# Remove composer 2* to install compoer 1.10.15
RUN rm /usr/bin/composer
RUN curl -O https://getcomposer.org/download/1.10.15/composer.phar
RUN mv composer.phar  /usr/bin/composer
RUN chmod a+x /usr/bin/composer

# Install Mysql Server
RUN apt-get install -y mysql-server mysql-client
COPY ./mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
COPY ./my.cnf /etc/mysql/my.cnf
COPY ./configMySQL.sh .
COPY ./startup.sh .
RUN /tmp/configMySQL.sh

# Install Nginx
RUN apt-get install -y nginx wget

# Set permissions to mysql
RUN chmod -R 755 /var/lib/mysql/

# Install NodeJS 8.9.4
RUN wget https://nodejs.org/dist/v8.9.4/node-v8.9.4-linux-x64.tar.gz
RUN tar -C /usr/local --strip-components 1 -xzf node-v8.9.4-linux-x64.tar.gz

CMD bash /tmp/startup.sh