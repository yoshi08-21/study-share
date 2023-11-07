

lock '3.17.3'

set :application, 'study_share'
set :deploy_to, '/var/www/study-share/backend'

set :repo_url, 'git@github.com:yoshi08-21/study-share.git'
set :branch, 'main'

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :rbenv_type, :user
set :rbenv_ruby, '3.0.3'

set :ssh_options, auth_methods: ['publickey'],
                  keys: ['~/.ssh/id_rsa']

set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }

set :unicorn_config_path, -> { "#{current_path}/backend/config/unicorn.rb" }
set :keep_releases, 5

namespace :deploy do
  namespace :assets do
    task :precompile do

    end
  end
end

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end

