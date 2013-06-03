#!/bin/bash -x
echo "load bashrc"
source ~/.bashrc

echo 'switch gemset'
rvm use ruby-1.9.3-p429@cakeside

echo 'bundle install'
bundle install --without production
cp config/database.yml.example config/database.yml
bundle exec rake ci --trace
