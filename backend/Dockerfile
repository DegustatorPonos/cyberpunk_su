FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y \
    redis-server \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /app

COPY ./app /app
COPY ./Settings_deployment.json /app/Settings.json
COPY ./.env /app
COPY ./libhiredis.so.* /app

ENV LD_LIBRARY_PATH=/usr/local/lib:/app

COPY ./entry.sh /app/entry.sh
RUN chmod +x /app/entry.sh

EXPOSE 9001
CMD ["./entry.sh"]
