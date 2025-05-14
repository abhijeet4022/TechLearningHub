#!/bin/bash

# Function to display a stylish start banner
print_start_banner() {
  local script_name=$(basename "$0")
  local width=80
  local padding=$(( (width - ${#script_name} - 18) / 2 ))
  local line=$(printf '%*s' "$width" | tr ' ' '━')
  local space=$(printf '%*s' "$width")
  local pad_space=$(printf '%*s' "$padding")

  echo
  echo -e "\e[1;34m┏${line}┓\e[0m"
  echo -e "\e[1;34m┃${space}┃\e[0m"
  echo -e "\e[1;34m┃${pad_space}\e[1;97m🚀 STARTING: $script_name 🚀\e[1;34m${pad_space}┃\e[0m"
  echo -e "\e[1;34m┃${space}┃\e[0m"
  echo -e "\e[1;34m┗${line}┛\e[0m"
  echo
}

# Function to display a stylish end banner for success
print_end_banner() {
  local script_name=$(basename "$0")
  local width=80
  local padding=$(( (width - ${#script_name} - 18) / 2 ))
  local line=$(printf '%*s' "$width" | tr ' ' '━')
  local space=$(printf '%*s' "$width")
  local pad_space=$(printf '%*s' "$padding")

  echo
  echo -e "\e[1;32m┏${line}┓\e[0m"
  echo -e "\e[1;32m┃${space}┃\e[0m"
  echo -e "\e[1;32m┃${pad_space}\e[1;97m✅ COMPLETED: $script_name ✅\e[1;32m${pad_space}┃\e[0m"
  echo -e "\e[1;32m┃${space}┃\e[0m"
  echo -e "\e[1;32m┗${line}┛\e[0m"
  echo
}

# Function to display a stylish end banner for failure
print_error_banner() {
  local script_name=$(basename "$0")
  local width=80
  local padding=$(( (width - ${#script_name} - 16) / 2 ))
  local line=$(printf '%*s' "$width" | tr ' ' '━')
  local space=$(printf '%*s' "$width")
  local pad_space=$(printf '%*s' "$padding")

  echo
  echo -e "\e[1;31m┏${line}┓\e[0m"
  echo -e "\e[1;31m┃${space}┃\e[0m"
  echo -e "\e[1;31m┃${pad_space}\e[1;97m❌ FAILED: $script_name ❌\e[1;31m${pad_space}┃\e[0m"
  echo -e "\e[1;31m┃${space}┃\e[0m"
  echo -e "\e[1;31m┗${line}┛\e[0m"
  echo
}