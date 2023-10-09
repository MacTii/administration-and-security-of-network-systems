#!/bin/bash

count=$1

for ((i=1; i<=count; i++)); do
  read -p "Enter the username for account $i: " username
  read -sp "Enter the password for account $i: " password
  useradd $username
  echo "$username:$password" | chpasswd
  echo "Added account $username with password $password"
done