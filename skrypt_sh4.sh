#!/bin/bash

input_method=$1
count=$2

if [ $input_method -eq 0 ]; then
  for ((i=1; i<=count; i++)); do
    read -p "Enter the username for account $i: " username
    read -sp "Enter the password for account $i: " password
    useradd $username
    echo "$username:$password" | chpasswd
    echo "Added account $username with password $password"
  done
elif [ $input_method -eq 1 ]; then
  if [ -z "$count" ]; then
    echo "No file path provided!"
    exit 1
  fi
  while IFS=: read username password; do
    useradd $username
    echo "$username:$password" | chpasswd
    echo "Added account $username with password $password"
  done < "$count"
else
  echo "Invalid input method!"
  exit 1
fi