require "bundler/capistrano"

set :user, "nginx"
set :use_sudo, false
set :ssh_options, { :forward_agent => true }

# For rbenv
set :default_environment, {
	  'PATH' => "/home/#{user}/.rbenv/shims:/home/#{user}/.rbenv/bin:$PATH"
}

set :domain, "pc-info8-servens.educ.insa"
set :application, "timetablesonrails"
default_run_options[:pty] = true

set :scm, :git
set :repository,  "/home/#{user}/git/#{application}.git"
set :local_repository,  "#{user}@#{domain}:git/#{application}.git"
set :branch, 'master'
set :deploy_via, :remote_cache

set :keep_releases, 5
set :deploy_to, "/home/#{user}/www/#{application}"

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

# Unicorn tasks
set :unicorn_exec, "/etc/init.d/unicorn_timetablesonrails"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "#{unicorn_exec} start"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "#{unicorn_exec} stop"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "#{unicorn exec} reload"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
		run "#{unicorn_exec} stop && #{unicorn_exec} start"
  end
end

# We want to keep existing uploads when deploying a new release
set :shared_assets, %w{public/uploads}

namespace :assets  do
  namespace :symlinks do
    desc "Setup application symlinks for shared assets"
    task :setup, :roles => [:app, :web] do
      shared_assets.each { |link| run "mkdir -p #{shared_path}/#{link}" }
    end

    desc "Link assets for current deploy to the shared location"
    task :update, :roles => [:app, :web] do
      shared_assets.each { |link| run "ln -fs #{shared_path}/#{link} #{release_path}/#{link}" }
    end
  end
end

# Copy database.yml
namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end
end

after 'deploy:update_code', 'deploy:symlink_db'

before "deploy:setup" do
  assets.symlinks.setup
end

before "deploy:symlink" do
  assets.symlinks.update
end

after "deploy", "deploy:migrate"
