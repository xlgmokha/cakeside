git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone https://github.com/tpope/rbenv-ctags.git ~/.rbenv/plugins/rbenv-ctags
git clone https://github.com/rkh/rbenv-update.git ~/plugins/rbenv-update
git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
rbenv update
rbenv install 2.1.4
rbenv global 2.1.4
gem install bundler --no-ri --no-rdoc
rbenv rehash
cd /vagrant
bundle install -j 4
rbenv rehash
if [ ! -f /vagrant/config/database.yml ]; then
  ln -s config/database.yml.vagrant config/database.yml
fi
if [ ! -f /vagrant/.env ]; then
  ln -s .env.example .env
fi
bundle exec rake db:create db:migrate db:seed
