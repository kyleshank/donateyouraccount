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