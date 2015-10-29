# https://github.com/brandonhilkert/sucker_punch#active-job
# http://guides.rubyonrails.org/active_job_basics.html
Rails.application.configure do
  config.active_job.queue_adapter = :sucker_punch
end
