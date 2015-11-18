FactoryGirl.define do
  sequence :public_access_token_seq do |n|
    "some-unique-token-#{n}"
  end

  factory :workout do
    association :user, factory: :user, strategy: :build
    kind 'cycling'
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
    power_avg nil
    power_weighted_avg nil
    power_max nil
    energy_output nil
    heart_rate_avg nil
    heart_rate_max nil
    weight_before nil
    weight_after nil
    strava_url nil
    strava_data { {} }
    garmin_connect_url nil
    garmin_connect_data { {} }
  end

  factory :done_workout, class: Workout do
    association :user, factory: :user, strategy: :build
    kind 'cycling'
    scheduled_on { Time.zone.yesterday }
    occurred_on { Time.zone.yesterday }
    name 'a workout I did yesterday'
    description 'go long and hard'
    observations 'went long and hard'
    coach_observations 'very good'
    distance 23345.67
    elapsed_time 5432
    moving_time 4567
    speed_avg 34.56
    speed_max 45.67
    cadence_avg 89
    cadence_max 123
    calories 1234
    elevation_gain 2345.6
    temperature_avg 23.4
    temperature_max 34.5
    temperature_min 12.3
    power_avg 234.5
    power_weighted_avg 123.4
    power_max 345.6
    energy_output 2345.6
    heart_rate_avg 167
    heart_rate_max 178
    weight_before 74.7
    weight_after 73.4
    strava_url 'https://www.strava.com/activities/421201541'
    strava_data { {"id"=>421201541, "resource_state"=>2, "external_id"=>"garmin_push_939552911", "upload_id"=>471162968} }
    garmin_connect_url 'https://connect.garmin.com/modern/activity/939552911'
    garmin_connect_data { {} }
  end

end
