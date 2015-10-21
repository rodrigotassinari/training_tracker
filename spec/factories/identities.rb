FactoryGirl.define do
  sequence :uid_seq do |n|
    "123#{n}"
  end

  factory :identity do
    association :user, factory: :user, strategy: :build
    provider "strava"
    uid { generate(:uid_seq) }
    info { {"name"=>"John Doe", "email"=>"john.doe@example.com", "location"=>"New York NY", "last_name"=>"Doe", "first_name"=>"John"}.to_json }
    credentials { {"token"=>"8a7be76f40f91c32f34ef34a129208ab0aad7d99", "expires"=>false}.to_json }
    extra { {"raw_info"=>{"id"=>1234567, "ftp"=>nil, "sex"=>"M", "city"=>"New York", "bikes"=>[{"id"=>"b1500344", "name"=>"Old Bike", "primary"=>false, "distance"=>86716.0, "resource_state"=>2}, {"id"=>"b1234288", "name"=>"Current Bike", "primary"=>true, "distance"=>6057094.0, "resource_state"=>2}], "clubs"=>[{"id"=>12345, "name"=>"Some Club", "profile"=>"https://dgalywyr863hv.cloudfront.net/pictures/clubs/38174/1036347/4/large.jpg", "profile_medium"=>"https://dgalywyr863hv.cloudfront.net/pictures/clubs/38174/1036347/4/medium.jpg", "resource_state"=>2}], "email"=>"john.doe@example.com", "shoes"=>[{"id"=>"g199111", "name"=>"Current Shoes", "primary"=>true, "distance"=>9000.0, "resource_state"=>2}], "state"=>"NY", "friend"=>nil, "weight"=>75.0, "country"=>"USA", "premium"=>true, "profile"=>"https://dgalywyr863hv.cloudfront.net/pictures/athletes/1234567/913413/2/large.jpg", "follower"=>nil, "lastname"=>"Doe", "firstname"=>"John", "created_at"=>"2013-08-22T15:32:03Z", "updated_at"=>"2015-10-02T06:02:51Z", "athlete_type"=>0, "friend_count"=>46, "badge_type_id"=>1, "follower_count"=>45, "profile_medium"=>"https://dgalywyr863hv.cloudfront.net/pictures/athletes/1234567/913413/2/medium.jpg", "resource_state"=>3, "date_preference"=>"%d/%m/%Y", "mutual_friend_count"=>0, "measurement_preference"=>"meters"}, "all_ride_totals"=>nil, "ytd_ride_totals"=>nil, "recent_ride_totals"=>nil}.to_json }
  end

end
