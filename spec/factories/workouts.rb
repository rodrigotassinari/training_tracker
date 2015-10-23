FactoryGirl.define do

  factory :workout do
    association :user, factory: :user, strategy: :build
    kind "cycling"
    scheduled_on { Time.zone.tomorrow }
    occurred_on nil
    name nil
    description nil
    observations nil
    coach_observations nil
    distance nil
    elapsed_time nil
    moving_time nil
    speed_avg nil
    speed_max nil
    cadence_avg nil
    cadence_max nil
    calories nil
    elevation_gain nil
    temperature_avg nil
    temperature_max nil
    temperature_min nil
    watts_avg nil
    watts_weighted_avg nil
    watts_max nil
    heart_rate_avg nil
    heart_rate_max nil
    weight_before nil
    weight_after nil
  end

end
