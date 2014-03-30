#!/bin/bash -x
echo "load bashrc"
#source ~/.bashrc
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

echo 'switch gemset'
rvm use ruby-2.1.1@cakeside --create

echo 'bundle install'
bundle install --without production
cp config/database.yml.example config/database.yml
bundle exec rake ci --trace
