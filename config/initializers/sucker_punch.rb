# https://github.com/brandonhilkert/sucker_punch#active-job
# http://guides.rubyonrails.org/active_job_basics.html

# If you want to use Sucker Punch version 2.0.0+ with Rails < 5.0.0, be sure to include the backwards compatibility module:
require 'sucker_punch/async_syntax'

Rails.application.configure do
  config.active_job.queue_adapter = :sucker_punch
end
