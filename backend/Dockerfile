FROM alpine:3.22.4
RUN apk update

# Installing zig
# RUN apk add zig=0.15.2-r0

# Installing redis
RUN apk add redis redis-openrc git build-base make
# RUN rc-update add redis default
RUN git clone https://github.com/redis/hiredis.git && cd hiredis && make install

WORKDIR /app
COPY ./app /app/app
# RUN make build
EXPOSE 6969
CMD ["./app"]
