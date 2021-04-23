FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && \
 apt-get -y install apache2

#RUN ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
#RUN echo 'Asia/Taipei' >/etc/timezone

# Install apache and write hello world message
RUN echo 'Hello World!' > /var/www/html/index.html
COPY ./efs/container-ssl/certificate.crt /root/
COPY ./efs/container-ssl/private.key /root/
COPY ./efs/container-ssl/ca_bundle.crt /root/
COPY ./efs/container-ssl/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf

# Configure apache
RUN echo '. /etc/apache2/envvars' > /root/run_apache.sh && \
 echo 'mkdir -p /var/run/apache2' >> /root/run_apache.sh && \
 echo 'mkdir -p /var/lock/apache2' >> /root/run_apache.sh && \ 
 echo 'a2enmod ssl' >> /root/run_apache.sh && \
 echo 'a2ensite default-ssl.conf' >> /root/run_apache.sh && \
 echo '/usr/sbin/apache2 -D FOREGROUND' >> /root/run_apache.sh && \ 
 chmod 755 /root/run_apache.sh

EXPOSE 443

CMD /root/run_apache.sh
