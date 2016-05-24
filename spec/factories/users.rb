FactoryGirl.define do
  sequence :email_seq do |n|
    "person#{n}@example.com"
  end

  factory :user do
    name "John Doe"
    email { generate(:email_seq) }
    garmin_connect_username "johndoe"
    locale "en"
    time_zone "Eastern Time (US & Canada)"

    factory :incomplete_user do
      email nil
      garmin_connect_username nil
    end

    factory :user_with_identity do
      transient do
        identities_count 1
      end
      after(:create) do |user, evaluator|
        create_list(:identity, evaluator.identities_count, user: user)
      end
    end
  end

end
