#!/bin/bash

# Get the input method and number of accounts or file path from the user
input_method=$1
input=$2

# Set the minimum password length
min_length=8

# Function to check if a password meets the requirements
check_password() {
  # Check the password length
  if [ ${#1} -lt $min_length ]; then
    return 1
  fi
  # Check if the password contains at least one uppercase letter, one digit, and one special character
  if [[ ! $1 =~ [A-Z] ]] || [[ ! $1 =~ [0-9] ]] || [[ ! $1 =~ [^A-Za-z0-9] ]]; then
    return 1
  fi
  return 0
}

# If the input method is 0, input the data manually
if [ $input_method -eq 0 ]; then
  # Loop through the number of accounts
  for ((i=1; i<=input; i++)); do
    # Read in the username
    read -p "Enter the username for account $i: " username
    # Read in the password
    while true; do
      read -sp "Enter the password for account $i: " password
      # Check if the password meets the requirements
      if check_password $password; then
        break
      else
        echo "Password does not meet the requirements!"
      fi
    done
    # Create the new user account
    useradd $username
    # Change the password for the user account
    echo "$username:$password" | chpasswd
    # Display a message about adding the account
    echo "Added account $username with password $password"
  done
# If the input method is 1, read the data from a file
elif [ $input_method -eq 1 ]; then
  # Check if a file path was provided
  if [ -z "$input" ]; then
    echo "No file path provided!"
    exit 1
  fi
  # Read the username and passwords from the file
  while IFS=: read username password; do
    # Check if the password meets the requirements
    if check_password $password; then
      # Create the new user account
      useradd $username
      # Change the password for the user account
      echo "$username:$password" | chpasswd
      # Display a message about adding the account
      echo "Added account $username with password $password"
    else
      # If the password does not meet the requirements, display an error message
      echo "Password for account $username does not meet the requirements!"
    fi
  done < "$input"
else
  # If an invalid input method was provided, display an error message
  echo "Invalid input method!"
  exit 1
fi