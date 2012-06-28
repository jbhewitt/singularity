#require ‘bundler/capistrano’
set :rvm_type, :system  # Copy the exact line. I really mean :system here
before 'deploy:setup', 'rvm:install_rvm'

set :application, "singularity"

set :scm, "git"
set :repository, "https://github.com/jbhewitt/singularity.git"
set :branch, "master"

set :rvm_type, :user
set :rvm_ruby_string, '1.9.3'
 
role :web, "apps.ls"                          # Your HTTP server, Apache/etc
role :app, "apps.ls"                          # This may be the same as your `Web` server
role :db,  "apps.ls", :primary => true # This is where Rails migrations will run

set :user, "singularity"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:compression] = "none"


after 'deploy:update_code', 'deploy:symlink_uploads'


namespace :deploy do
	task :symlink_uploads do
		run "ln -nfs #{shared_path}/config/settings  #{release_path}/rails/config/settings"
		run "ln -nfs #{shared_path}/public/tokens  #{release_path}/rails//public/tokens"
		run "ln -nfs #{shared_path}/public/uploads  #{release_path}/rails//public/uploads"
		run "ln -nfs #{shared_path}/public/badges  #{release_path}/rails//public/badges"
	end
end


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end