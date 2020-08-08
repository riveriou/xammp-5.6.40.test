FROM ubuntu:latest
MAINTAINER River riou

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

RUN ln -snf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && echo Asia/Taipei > /etc/timezone

RUN apt-get update
RUN apt-get install -y curl wget vim nano lsof net-tools dialog software-properties-common less unzip --no-install-recommends
RUN wget https://nchc.dl.sourceforge.net/project/xampp/XAMPP%20Linux/5.6.40/xampp-linux-x64-5.6.40-1-installer.run
RUN chmod +x /xampp-linux-x64-5.6.40-1-installer.run
RUN ./xampp-linux-x64-5.6.40-1-installer.run

RUN ln -sf /opt/lampp/lampp /usr/bin/lampp
RUN ln -sf /opt/lampp/bin/mysql /usr/bin/
RUN echo "<?PHP phpinfo(); ?>" >> /opt/lampp/htdocs/test.php

RUN apt-get install -y supervisor
RUN apt-get clean

RUN echo "[supervisord] " >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "user=root" >> /etc/supervisor/conf.d/supervisord.conf

VOLUME [ "/var/log/mysql/", "/var/log/apache2/" ]

EXPOSE 80

# write a startup script
RUN echo '/opt/lampp/lampp start' >> /startup.sh
RUN echo '/usr/bin/supervisord -n' >> /startup.sh

CMD ["sh", "/startup.sh"]
