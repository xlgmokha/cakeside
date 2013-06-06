#!/bin/bash -x
echo "load bashrc"
source ~/.bashrc

echo 'switch gemset'
rvm use ruby-2.0.0-p195@cakeside --create

echo 'bundle install'
git checkout master
bundle exec rake ci:deploy_staging --trace
