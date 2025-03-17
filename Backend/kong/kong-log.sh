#!/bin/sh

mkdir -p /tmp/kong

chown kong:kong /tmp/kong

chmod 755 /tmp/kong

exec "$@"