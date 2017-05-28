# Lets-Encrypt
# Cogset Open Source Group

FROM cogset/cron:latest

MAINTAINER Cogset <cogset@funcuter.org>

# Install
RUN apt-get update \
    && apt-get install -y --no-install-recommends git ca-certificates python3 \
    && git clone https://github.com/letsencrypt/letsencrypt /usr/local/letsencrypt \
    && ln -s /usr/local/letsencrypt/letsencrypt-auto /usr/bin/letsencrypt-auto \
    && letsencrypt-auto certificates \
    && rm -rf /var/lib/apt/lists/*

COPY letsencrypt-*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/letsencrypt-*.sh

ENTRYPOINT ["letsencrypt-entrypoint.sh"]

CMD ["obtain"]
