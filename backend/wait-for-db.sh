#!/bin/sh

set -e

cmd="$@"

retryCount=1
until nc -z db 5432; do
  >&2 echo "Wait for DB to become available  - retry $retryCount"
  sleep 3

  retryCount=$(( $retryCount + 1))
  if [ "$retryCount" -eq 10 ]
    then
        break
    fi
done

>&2 echo "DB is up - executing command"
echo $cmd
exec $cmd