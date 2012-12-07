##
# Donate Your Account (donateyouraccount.com)
# Copyright (C) 2011  Kyle Shank (kyle.shank@gmail.com)
# http://www.gnu.org/licenses/agpl.html
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
##

# Load RVM's capistrano plugin.
require "rvm/capistrano"

set :rvm_ruby_string, '1.9.3'
set :rvm_type, :user  # Don't use system-wide RVM

set :application, "dya"
set :hostname, (ENV['HOST'] || "donateyouraccount.com")

set :user, "dya"
set :host, "#{user}@#{hostname}"

set :scm, :git
set :repository,  "git@github.com:kyleshank/donateyouraccount.git"
set :use_sudo, false
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :deploy_to, "/a/#{application}"
set :deploy_via, :remote_cache
set :runner, user
set :keep_releases, 10

role :app, hostname
role :web, hostname
role :db,  hostname, :primary => true
role :worker, hostname

namespace :deploy do
  desc "Start Unicorn"
  task :start, :roles => :app do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec thin -C #{deploy_to}/shared/thin.yml start"
  end

  desc "Restart Unicorn"
  task :restart, :roles => :app do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec thin -C #{deploy_to}/shared/thin.yml restart"
  end

  desc "Stop Unicorn"
  task :stop, :roles => :app do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec thin -C #{deploy_to}/shared/thin.yml stop"
  end

  task :symlink_config do
    run "ln -sf #{deploy_to}/shared/database.yml #{release_path}/config/database.yml"
    run "ln -sf #{deploy_to}/shared/production.rb #{release_path}/config/environments/production.rb"
  end

  task :migrate, :roles => :db do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake db:migrate"
  end
end

namespace :bundler do
  task :create_symlink do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, 'vendor','bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end

  task :bundle_new_release do
    run "bundle install --gemfile #{release_path}/Gemfile --path #{deploy_to}/shared/bundle --deployment --without cucumber test"
    bundler.create_symlink
  end
end

namespace :delayed_job do
  desc "Restart Unicorn"
  task :start, :roles => :worker do
    run("cd #{deploy_to}/current; RAILS_ENV=production bundle exec script/delayed_job -n 1 start")
  end

  task :stop, :roles => :worker do
    run("cd #{deploy_to}/current; RAILS_ENV=production bundle exec script/delayed_job stop")
  end
  
  task :restart, :roles => :worker do
    run("cd #{deploy_to}/current; RAILS_ENV=production bundle exec script/delayed_job restart")
  end
end

after 'deploy:update_code', 'bundler:bundle_new_release', "deploy:symlink_config"
after "deploy:update", "deploy:cleanup"