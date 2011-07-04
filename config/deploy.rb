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
#require "bundler/capistrano"

set :application, "dya"
set :hostname, "donateyouraccount.com"

set :user, "dya"
set :host, "#{user}@#{hostname}"

set :scm, :git
set :repository,  "git@github.com:kyleshank/donateyouraccount.git"
set :use_sudo, false
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache
set :runner, user
set :keep_releases, 10

role :app, "donateyouraccount.com"
role :web, "donateyouraccount.com"
role :db,  "donateyouraccount.com", :primary => true

namespace :deploy do
  desc "Restart Unicorn"
  task :restart do
    run "kill -USR2 `cat #{deploy_to}/shared/pids/unicorn.pid`"
    run("cd #{deploy_to}/current; RAILS_ENV=production script/delayed_job restart")
  end

  task :symlink_config, :roles => :app do
    run "ln -sf #{deploy_to}/shared/database.yml #{release_path}/config/database.yml"
    run "ln -sf #{deploy_to}/shared/production.rb #{release_path}/config/environments/production.rb"
  end

end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, 'vendor','bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end

  task :bundle_new_release, :roles => :app do
    run "bundle install --gemfile #{release_path}/Gemfile --path /var/www/dya/shared/bundle --deployment --without cucumber test"
    bundler.create_symlink
  end
end

after 'deploy:update_code', 'bundler:bundle_new_release', "deploy:symlink_config"
after "deploy:update", "deploy:cleanup"