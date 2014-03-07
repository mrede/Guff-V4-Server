# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'LabelPusher'
set :repo_url, 'git@github.com:mrede/Guff-V4-Server.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/http/dev.guff.me.uk'

# Default value for :log_level is :debug
# set :log_level, :debug

set :deploy_user, 'label'

# how many old releases do we want to keep
set :keep_releases, 5

# files we want symlinking to specific entries in shared.
#set :linked_files, %w{config/database.yml config/application.yml}

# dirs we want symlinking to shared
#set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, ["spec"]

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
# set(:config_files, %w(
#   nginx.conf
#   application.yml
#   database.example.yml
#   log_rotation
#   monit
#   unicorn.rb
#   unicorn_init.sh
# ))

# which config files should be made executable after copying
# by deploy:setup_config
# set(:executable_config_files, %w(
#   unicorn_init.sh
# ))

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc.
# set(:symlinks, [
#   {
#     source: "nginx.conf",
#     link: "/etc/nginx/sites-enabled/#{fetch(:full_app_name)}"
#   },
#   {
#     source: "unicorn_init.sh",
#     link: "/etc/init.d/unicorn_#{fetch(:full_app_name)}"
#   },
#   {
#     source: "log_rotation",
#    link: "/etc/logrotate.d/#{fetch(:full_app_name)}"
#   },
#   {
#     source: "monit",
#     link: "/etc/monit/conf.d/#{fetch(:full_app_name)}.conf"
#   }
# ])


# this:
# http://www.capistranorb.com/documentation/getting-started/flow/
# is worth reading for a quick overview of what tasks are called
# and when for `cap stage deploy`


 namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
