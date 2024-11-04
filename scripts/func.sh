#!/bin/bash

install_package() {
  local package_name="$1"
  if [ -z "$package_name" ]; then
    echo "Error: Package name is not provided"
    return 1
  else
    echo "Installing package $package_name..."
    sudo dnf install -y "$package_name"
    return 0
  fi
}

start_service() {
  local package_name="$1"
  if [[ -z "$package_name" ]]; then
    echo "Error: Service name is not provided"
    return 1
  else
    echo "Starting service $package_name..."
    sudo systemctl start "$package_name"
    sudo systemctl enable "$package_name"
    return 0
  fi
}
