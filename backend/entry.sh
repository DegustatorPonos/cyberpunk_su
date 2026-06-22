#!/bin/sh
redis-server --daemonize yes

sleep 1

exec ./app
