#!/bin/bash

nginx &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start nginx: $status"
  exit $status
fi


mysqld --user=root --sql-mode="" &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start mysql: $status"
  exit $status
fi

php-fpm &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start php-fpm: $status"
  exit $status
fi

checked=0
while sleep 60; do
  ps aux |grep nginx |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep mysqld |grep -q -v grep
  PROCESS_2_STATUS=$?
  ps aux |grep php-fpm |grep -q -v grep
  PROCESS_3_STATUS=$?
  
  
  if [ $PROCESS_1_STATUS -ne 0 ]; then
    echo "nginx process has already exited."
    exit 1
  fi

  if [ $PROCESS_2_STATUS -ne 0 ]; then
    echo "mysql process has already exited."
    exit 1
  else
    if [ $checked -ne 1 ]; then
      checked=1
    fi
  fi

  if [ $PROCESS_3_STATUS -ne 0 ]; then
    echo "php-fpm process has already exited."
    exit 1
  fi
done