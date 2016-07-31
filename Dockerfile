FROM node:0.10.45
MAINTAINER "Mike Pham (support@nativecode.com)"

# Environment variables.
ENV SINOPIA_PREFIX https://localhost

# App contents.
WORKDIR /opt/sinopia/conf.d
ADD docker-entrypoint.sh /docker-entrypoint.sh
ADD templates/config.yaml config.yaml
ADD templates/.sinopia-db.json .sinopia-db.json

# Run package installer first so rebuilding the image is faster.
RUN set -x \
	&& apt-get update \
	&& apt-get -y install whois \
	&& npm install --global --prefix /opt/sinopia --production --silent sinopia > /dev/null \
	&& chown daemon:root -R /opt/sinopia \
    && ln -s /opt/sinopia/bin/sinopia /usr/local/bin/sinopia \
    && chown root:root /docker-entrypoint.sh \
    && chmod +x /docker-entrypoint.sh \
;

# Expose ports and volumes.
EXPOSE 4873
RUN mkdir /data ; chown daemon:root /data
VOLUME ["/data/sinopia"]

# Run process.
ENTRYPOINT ["/docker-entrypoint.sh"]
