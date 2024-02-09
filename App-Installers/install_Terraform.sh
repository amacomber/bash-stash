#!/bin/bash


if [[ $(arch) == 'arm64' ]]; then
  echo "Apple Silicon"
  # Download ARM binary
  curl -L -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.5.5/terraform_1.5.5_darwin_arm64.zip
  # Unzip file
  cd /tmp
  unzip /tmp/terraform.zip
  # Move to /usr/local/bin
  mv /tmp/terraform /usr/local/bin/
else
  echo "Intel"
  # Download Intel binary
  curl -L -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.5.5/terraform_1.5.5_darwin_amd64.zip
  # Unzip file
  cd /tmp
  unzip /tmp/terraform.zip
  # Move to /usr/local/bin
  mv /tmp/terraform /usr/local/bin/
fi