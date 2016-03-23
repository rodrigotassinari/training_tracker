workers Integer(ENV['PUMA_WORKERS'] || 2)
threads Integer(ENV['PUMA_MIN_THREADS'] || 5), Integer(ENV['PUMA_MAX_THREADS'] || 5)

preload_app!

rackup DefaultRackup
port Integer(ENV['PORT'] || 3000)
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  # Valid on Rails 4.1+ using the `config/database.yml` method of setting `pool` size
  ActiveRecord::Base.establish_connection
end
