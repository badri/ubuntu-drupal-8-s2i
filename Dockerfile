FROM ubuntu:16.04

LABEL maintainer="Lakshmi Narasimhan <lakshmi@lakshminp.com>"

ENV UBUNTU_RELEASE=xenial \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    ACCEPT_EULA=y \
    HOME=/opt/app-root/src

LABEL io.k8s.description="Base image for Nginx" \
      io.k8s.display-name="OpenShift Nginx" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder, Nginx"

RUN apt-get update && apt-get install -y nginx \
    && apt-get install -y locales \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



COPY ./s2i/bin/ /usr/libexec/s2i

COPY ./files/nginx.conf /etc/nginx/
COPY ./files/drupal /etc/nginx/conf.d/

RUN groupadd --gid 1001 s2i && useradd --gid 1001 --uid 1001 -m s2i && \
mkdir -p ${HOME} && \
chown -R 1001:1001 ${HOME}


RUN chown -R 1001:1001 /usr/share/nginx
RUN chown -R 1001:1001 /var/log/nginx
RUN chown -R 1001:1001 /var/lib/nginx
RUN touch /run/nginx.pid
RUN chown -R 1001:1001 /run/nginx.pid
RUN chown -R 1001:1001 /etc/nginx


WORKDIR ${HOME}

EXPOSE 8080

USER 1001

CMD ["/usr/libexec/s2i/usage"]
