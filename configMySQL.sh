#!/bin/bash
apt-get intall -y expect 

MYSQL_ROOT_PASSWORD="root"

SECURE_MYSQL=$(expect -c "

set timeout 10
spawn mysql_secure_installation

expect "Enter current password for root (enter for none):"
send "$MYSQL\r"

expect "Set root password?"
send "y\r"

expect "New password:"
send "$MYSQL_ROOT_PASSWORD\r"

expect "Re-enter new password:"
send "$MYSQL_ROOT_PASSWORD\r"

expect "Remove anonymous users?"
send "y\r"

expect "Disallow root login remotely?"
send "n\r"

expect "Remove test database and access to it?"
send "y\r"

expect "Reload privilege tables now?"
send "y\r"
expect eof
")

echo "$SECURE_MYSQL"