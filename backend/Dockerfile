FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y \
    redis-server \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /app
COPY ./app /app
COPY ./Settings.json /app
COPY ./.env /app
COPY ./libhiredis.so.1.3.0 /app

ENV LD_LIBRARY_PATH=/usr/local/lib:/app

COPY ./entry.sh /app/entry.sh
RUN chmod +x /app/entry.sh

EXPOSE 6969
CMD ["./entry.sh"]
