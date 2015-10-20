Rails.application.config.after_initialize do
  ActiveRecord::Base.connection_pool.disconnect!

  ActiveSupport.on_load(:active_record) do
    if config = ActiveRecord::Base.configurations[Rails.env] || Rails.application.config.database_configuration[Rails.env]
      config['reaping_frequency'] = ENV.fetch('DATABASE_REAP_FREQ') || 10 # seconds
      config['pool']              = ENV.fetch('DATABASE_POOL')      || 5
      ActiveRecord::Base.establish_connection(config)
    end
  end
end
