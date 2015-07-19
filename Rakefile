# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

desc 'Resets the local deployment'
task 'reset:local' => %w(db:drop:all db:create:all db:migrate)

desc 'Deploys web to heroku'
task :deploy do
  `git push heroku master`
  # exec in clean_env -> http://stackoverflow.com/questions/23037148/why-do-i-get-a-rubyversionmismatch-when-calling-heroku-toolbelt-cli-with-rake
  Bundler.with_clean_env { p `heroku run rake db:migrate` }
end

desc 'Starts the integration environment'
task :start_integration_env do
  fork do
    Bundler.with_clean_env { `foreman start -e integration.env &` }
  end
end

desc 'Starts the development environment'
task :start_development_env do
  fork do
    Bundler.with_clean_env { `foreman start -e .env &` }
  end
end

desc 'Stops all environments'
task :stop_environments do
  `ps | grep foreman | grep -v grep | awk '{print "kill  " $1}' | sh`
end

